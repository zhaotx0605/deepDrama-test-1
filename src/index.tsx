import { Hono } from 'hono'
import { cors } from 'hono/cors'

type Bindings = {
  DB: D1Database
}

const app = new Hono<{ Bindings: Bindings }>()

// Enable CORS
app.use('/api/*', cors())

// ==================== API Routes ====================

// 1. 数据统计接口
app.get('/api/stats', async (c) => {
  try {
    const { DB } = c.env

    // 总剧本数
    const totalScripts = await DB.prepare('SELECT COUNT(*) as count FROM scripts').first()
    
    // 已立项数量
    const projectCount = await DB.prepare('SELECT COUNT(*) as count FROM scripts WHERE is_project = 1').first()
    
    // 待评分数量 (没有评分记录的剧本)
    const pendingRatings = await DB.prepare(`
      SELECT COUNT(*) as count FROM scripts s 
      WHERE NOT EXISTS (SELECT 1 FROM ratings r WHERE r.script_id = s.script_id)
    `).first()
    
    // 计算转化率
    const conversionRate = totalScripts?.count ? ((projectCount?.count || 0) / totalScripts.count * 100).toFixed(1) : '0.0'
    
    // 平均质量分 (所有剧本的最新评分的平均值)
    const avgScore = await DB.prepare(`
      SELECT AVG(total_score) as avg FROM (
        SELECT script_id, MAX(total_score) as total_score 
        FROM ratings 
        GROUP BY script_id
      )
    `).first()
    
    // 评级分布
    const gradeDistribution = await DB.prepare(`
      SELECT grade, COUNT(*) as count FROM (
        SELECT script_id, 
          CASE 
            WHEN MAX(total_score) >= 90 THEN 'S'
            WHEN MAX(total_score) >= 80 THEN 'A'
            WHEN MAX(total_score) >= 70 THEN 'B'
            WHEN MAX(total_score) >= 60 THEN 'C'
            ELSE 'D'
          END as grade
        FROM ratings 
        GROUP BY script_id
      )
      GROUP BY grade
    `).all()
    
    // 来源分布
    const sourceDistribution = await DB.prepare(`
      SELECT source_type, COUNT(*) as count 
      FROM scripts 
      GROUP BY source_type
    `).all()
    
    // 状态分布
    const statusDistribution = await DB.prepare(`
      SELECT status, COUNT(*) as count 
      FROM scripts 
      GROUP BY status
    `).all()
    
    // 月度趋势 (2025年6-12月)
    const monthlyTrend = await DB.prepare(`
      SELECT 
        strftime('%Y-%m', submit_date) as month,
        COUNT(*) as total,
        SUM(CASE WHEN script_id IN (
          SELECT script_id FROM ratings WHERE total_score >= 80
        ) THEN 1 ELSE 0 END) as high_quality
      FROM scripts
      WHERE submit_date >= '2025-06-01' AND submit_date <= '2025-12-31'
      GROUP BY month
      ORDER BY month
    `).all()

    return c.json({
      total_scripts: totalScripts?.count || 0,
      project_count: projectCount?.count || 0,
      pending_ratings: pendingRatings?.count || 0,
      conversion_rate: parseFloat(conversionRate),
      average_score: avgScore?.avg ? parseFloat(avgScore.avg.toFixed(2)) : 0,
      grade_distribution: gradeDistribution?.results || [],
      source_distribution: sourceDistribution?.results || [],
      status_distribution: statusDistribution?.results || [],
      monthly_trend: monthlyTrend?.results || []
    })
  } catch (error) {
    console.error('Stats error:', error)
    return c.json({ error: 'Failed to fetch stats' }, 500)
  }
})

// 2. 剧本列表接口
app.get('/api/scripts', async (c) => {
  try {
    const { DB } = c.env
    const { status, source, tag, minScore, maxScore, search, quickFilter } = c.req.query()

    let query = `
      SELECT 
        s.*,
        (
          SELECT MAX(r.total_score)
          FROM ratings r
          WHERE r.script_id = s.script_id
        ) as total_score,
        (
          SELECT CASE 
            WHEN MAX(r.compliance_score) < 60 THEN 'D'
            WHEN MAX(r.total_score) >= 90 THEN 'S'
            WHEN MAX(r.total_score) >= 80 THEN 'A'
            WHEN MAX(r.total_score) >= 70 THEN 'B'
            WHEN MAX(r.total_score) >= 60 THEN 'C'
            ELSE 'D'
          END
          FROM ratings r
          WHERE r.script_id = s.script_id
        ) as grade,
        (
          SELECT COUNT(*)
          FROM ratings r
          WHERE r.script_id = s.script_id
        ) as rating_count
      FROM scripts s
      WHERE 1=1
    `

    const params: any[] = []

    // 快捷筛选
    if (quickFilter === 'pending') {
      query += ` AND NOT EXISTS (SELECT 1 FROM ratings r WHERE r.script_id = s.script_id)`
    } else if (quickFilter === 's_potential') {
      query += ` AND EXISTS (SELECT 1 FROM ratings r WHERE r.script_id = s.script_id AND r.total_score >= 90)`
    } else if (quickFilter === 'project') {
      query += ` AND s.is_project = 1`
    }

    // 状态筛选
    if (status) {
      query += ` AND s.status = ?`
      params.push(status)
    }

    // 来源筛选
    if (source) {
      query += ` AND s.source_type = ?`
      params.push(source)
    }

    // 搜索
    if (search) {
      query += ` AND (s.name LIKE ? OR s.script_id LIKE ?)`
      params.push(`%${search}%`, `%${search}%`)
    }

    query += ` ORDER BY s.created_at DESC`

    const stmt = DB.prepare(query)
    const result = await stmt.bind(...params).all()

    // 过滤分数区间
    let scripts = result.results || []
    if (minScore || maxScore) {
      scripts = scripts.filter((s: any) => {
        if (!s.total_score) return false
        if (minScore && s.total_score < parseFloat(minScore)) return false
        if (maxScore && s.total_score > parseFloat(maxScore)) return false
        return true
      })
    }

    return c.json(scripts)
  } catch (error) {
    console.error('Scripts list error:', error)
    return c.json({ error: 'Failed to fetch scripts' }, 500)
  }
})

// 3. 剧本详情接口
app.get('/api/scripts/:id', async (c) => {
  try {
    const { DB } = c.env
    const scriptId = c.req.param('id')

    const script = await DB.prepare(`
      SELECT * FROM scripts WHERE script_id = ?
    `).bind(scriptId).first()

    if (!script) {
      return c.json({ error: 'Script not found' }, 404)
    }

    return c.json(script)
  } catch (error) {
    console.error('Script detail error:', error)
    return c.json({ error: 'Failed to fetch script' }, 500)
  }
})

// 4. 新增剧本接口
app.post('/api/scripts', async (c) => {
  try {
    const { DB } = c.env
    const body = await c.req.json()
    
    const { name, preview, file_url, tags, source_type, team, status, submit_date, submit_user } = body

    // 生成剧本ID (SP + 3位数字)
    const lastScript = await DB.prepare(`
      SELECT script_id FROM scripts ORDER BY id DESC LIMIT 1
    `).first()
    
    let nextNum = 1
    if (lastScript?.script_id) {
      const match = lastScript.script_id.match(/SP(\d+)/)
      if (match) {
        nextNum = parseInt(match[1]) + 1
      }
    }
    const script_id = `SP${String(nextNum).padStart(3, '0')}`

    await DB.prepare(`
      INSERT INTO scripts (script_id, name, preview, file_url, tags, source_type, team, status, submit_date, submit_user)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `).bind(
      script_id,
      name,
      preview || '',
      file_url || '',
      JSON.stringify(tags || []),
      source_type || '内部团队',
      team || '',
      status || '一卡初稿',
      submit_date || new Date().toISOString().split('T')[0],
      submit_user || ''
    ).run()

    return c.json({ success: true, script_id })
  } catch (error) {
    console.error('Create script error:', error)
    return c.json({ error: 'Failed to create script' }, 500)
  }
})

// 5. 更新剧本接口
app.put('/api/scripts/:id', async (c) => {
  try {
    const { DB } = c.env
    const scriptId = c.req.param('id')
    const body = await c.req.json()
    
    const { name, preview, file_url, tags, source_type, team, status, is_project } = body

    await DB.prepare(`
      UPDATE scripts 
      SET name = ?, preview = ?, file_url = ?, tags = ?, source_type = ?, team = ?, status = ?, is_project = ?
      WHERE script_id = ?
    `).bind(
      name,
      preview || '',
      file_url || '',
      JSON.stringify(tags || []),
      source_type,
      team || '',
      status,
      is_project ? 1 : 0,
      scriptId
    ).run()

    return c.json({ success: true })
  } catch (error) {
    console.error('Update script error:', error)
    return c.json({ error: 'Failed to update script' }, 500)
  }
})

// 6. 删除剧本接口
app.delete('/api/scripts/:id', async (c) => {
  try {
    const { DB } = c.env
    const scriptId = c.req.param('id')

    // 删除评分记录
    await DB.prepare(`DELETE FROM ratings WHERE script_id = ?`).bind(scriptId).run()
    
    // 删除剧本
    await DB.prepare(`DELETE FROM scripts WHERE script_id = ?`).bind(scriptId).run()

    return c.json({ success: true })
  } catch (error) {
    console.error('Delete script error:', error)
    return c.json({ error: 'Failed to delete script' }, 500)
  }
})

// 7. 获取评分历史
app.get('/api/scripts/:id/ratings', async (c) => {
  try {
    const { DB } = c.env
    const scriptId = c.req.param('id')

    const ratings = await DB.prepare(`
      SELECT 
        r.*,
        u.name as user_name,
        u.role as user_role
      FROM ratings r
      LEFT JOIN users u ON r.user_id = u.user_id
      WHERE r.script_id = ?
      ORDER BY r.created_at DESC
    `).bind(scriptId).all()

    return c.json(ratings.results || [])
  } catch (error) {
    console.error('Ratings history error:', error)
    return c.json({ error: 'Failed to fetch ratings' }, 500)
  }
})

// 8. 提交评分
app.post('/api/scripts/:id/ratings', async (c) => {
  try {
    const { DB } = c.env
    const scriptId = c.req.param('id')
    const body = await c.req.json()
    
    const { user_id, content_score, market_score, commercial_score, compliance_score, comments } = body

    // 计算加权总分
    let total_score = (content_score * 0.4) + (market_score * 0.3) + (commercial_score * 0.3)
    
    // 合规熔断机制
    if (compliance_score < 60) {
      total_score = 0 // D级
    }

    // 判定评级
    let grade = 'D'
    if (compliance_score >= 60) {
      if (total_score >= 90) grade = 'S'
      else if (total_score >= 80) grade = 'A'
      else if (total_score >= 70) grade = 'B'
      else if (total_score >= 60) grade = 'C'
    }

    await DB.prepare(`
      INSERT INTO ratings (script_id, user_id, content_score, market_score, commercial_score, compliance_score, total_score, grade, comments)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `).bind(
      scriptId,
      user_id || 'U001',
      content_score,
      market_score,
      commercial_score,
      compliance_score,
      total_score,
      grade,
      comments || ''
    ).run()

    return c.json({ success: true, total_score, grade })
  } catch (error) {
    console.error('Submit rating error:', error)
    return c.json({ error: 'Failed to submit rating' }, 500)
  }
})

// 9. 剧本排行榜
app.get('/api/scripts/rankings', async (c) => {
  try {
    const { DB } = c.env

    const rankings = await DB.prepare(`
      SELECT 
        s.*,
        MAX(r.total_score) as total_score,
        MAX(r.content_score) as content_score,
        MAX(r.market_score) as market_score,
        MAX(r.commercial_score) as commercial_score,
        CASE 
          WHEN MAX(r.compliance_score) < 60 THEN 'D'
          WHEN MAX(r.total_score) >= 90 THEN 'S'
          WHEN MAX(r.total_score) >= 80 THEN 'A'
          WHEN MAX(r.total_score) >= 70 THEN 'B'
          WHEN MAX(r.total_score) >= 60 THEN 'C'
          ELSE 'D'
        END as grade,
        COUNT(r.id) as rating_count
      FROM scripts s
      LEFT JOIN ratings r ON s.script_id = r.script_id
      WHERE r.id IS NOT NULL
      GROUP BY s.script_id
      ORDER BY total_score DESC
      LIMIT 100
    `).all()

    return c.json(rankings.results || [])
  } catch (error) {
    console.error('Rankings error:', error)
    return c.json({ error: 'Failed to fetch rankings' }, 500)
  }
})

// ==================== Frontend UI ====================
app.get('/', (c) => {
  return c.html(`
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DeepDrama - 剧本管理系统</title>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
    <script src="https://unpkg.com/echarts@5/dist/echarts.min.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://unpkg.com/@arco-design/web-vue@2/dist/arco.css" rel="stylesheet">
    <script src="https://unpkg.com/@arco-design/web-vue@2/dist/arco-vue.min.js"></script>
</head>
<body class="bg-gray-100">
    <div id="app" class="container mx-auto p-4">
        <h1 class="text-3xl font-bold mb-6 text-center text-blue-600">DeepDrama 剧本管理系统</h1>
        
        <!-- 数据看板 -->
        <div class="bg-white p-6 rounded-lg shadow-md mb-6">
            <h2 class="text-2xl font-bold mb-4">数据看板</h2>
            <div class="grid grid-cols-4 gap-4 mb-6">
                <div class="bg-blue-50 p-4 rounded">
                    <div class="text-gray-600 text-sm">剧本总数</div>
                    <div class="text-2xl font-bold">{{ stats.total_scripts }}</div>
                </div>
                <div class="bg-green-50 p-4 rounded">
                    <div class="text-gray-600 text-sm">转化率</div>
                    <div class="text-2xl font-bold">{{ stats.conversion_rate }}%</div>
                </div>
                <div class="bg-yellow-50 p-4 rounded">
                    <div class="text-gray-600 text-sm">待评数</div>
                    <div class="text-2xl font-bold">{{ stats.pending_ratings }}</div>
                </div>
                <div class="bg-purple-50 p-4 rounded">
                    <div class="text-gray-600 text-sm">平均分</div>
                    <div class="text-2xl font-bold">{{ stats.average_score }}</div>
                </div>
            </div>
            <div id="chart" style="height: 300px"></div>
        </div>

        <!-- 剧本列表 -->
        <div class="bg-white p-6 rounded-lg shadow-md">
            <h2 class="text-2xl font-bold mb-4">剧本列表</h2>
            
            <!-- 筛选器 -->
            <div class="mb-4 flex gap-2">
                <button @click="filter='all'" :class="buttonClass('all')" class="px-4 py-2 rounded">全部</button>
                <button @click="filter='pending'" :class="buttonClass('pending')" class="px-4 py-2 rounded">待评分</button>
                <button @click="filter='s_potential'" :class="buttonClass('s_potential')" class="px-4 py-2 rounded">S级潜力</button>
                <button @click="filter='project'" :class="buttonClass('project')" class="px-4 py-2 rounded">已立项</button>
            </div>

            <!-- 表格 -->
            <div class="overflow-x-auto">
                <table class="w-full border-collapse">
                    <thead>
                        <tr class="bg-gray-100">
                            <th class="border p-2 text-left">剧本ID</th>
                            <th class="border p-2 text-left">名称</th>
                            <th class="border p-2 text-left">评级</th>
                            <th class="border p-2 text-left">得分</th>
                            <th class="border p-2 text-left">来源</th>
                            <th class="border p-2 text-left">状态</th>
                            <th class="border p-2 text-left">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="script in scripts" :key="script.script_id" class="hover:bg-gray-50">
                            <td class="border p-2">{{ script.script_id }}</td>
                            <td class="border p-2">{{ script.name }}</td>
                            <td class="border p-2">
                                <span :class="gradeColor(script.grade)" class="px-2 py-1 rounded font-bold">
                                    {{ script.grade || '-' }}
                                </span>
                            </td>
                            <td class="border p-2">{{ script.total_score ? script.total_score.toFixed(1) : '-' }}</td>
                            <td class="border p-2">{{ script.source_type }}</td>
                            <td class="border p-2">{{ script.status }}</td>
                            <td class="border p-2">
                                <button @click="preview(script)" class="text-blue-500 hover:underline mr-2">预览</button>
                                <button @click="rate(script)" class="text-green-500 hover:underline mr-2">评分</button>
                                <button @click="deleteScript(script)" class="text-red-500 hover:underline">删除</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 评分弹窗 -->
        <div v-if="showRating" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white p-6 rounded-lg w-96 max-h-screen overflow-y-auto">
                <h3 class="text-xl font-bold mb-4">评分: {{ currentScript.name }}</h3>
                
                <div class="mb-4">
                    <label class="block mb-2">内容维度 (40%权重)</label>
                    <input v-model.number="rating.content_score" type="number" min="0" max="100" class="w-full border p-2 rounded">
                </div>
                
                <div class="mb-4">
                    <label class="block mb-2">市场维度 (30%权重)</label>
                    <input v-model.number="rating.market_score" type="number" min="0" max="100" class="w-full border p-2 rounded">
                </div>
                
                <div class="mb-4">
                    <label class="block mb-2">商业维度 (30%权重)</label>
                    <input v-model.number="rating.commercial_score" type="number" min="0" max="100" class="w-full border p-2 rounded">
                </div>
                
                <div class="mb-4">
                    <label class="block mb-2">合规维度 (一票否决)</label>
                    <input v-model.number="rating.compliance_score" type="number" min="0" max="100" class="w-full border p-2 rounded">
                    <p class="text-sm text-red-500">注意: 低于60分将强制评为D级</p>
                </div>
                
                <div class="mb-4">
                    <label class="block mb-2">评语</label>
                    <textarea v-model="rating.comments" class="w-full border p-2 rounded" rows="3"></textarea>
                </div>
                
                <div class="mb-4 p-4 bg-gray-100 rounded">
                    <div>预计总分: <span class="font-bold text-2xl">{{ calculatedScore }}</span></div>
                    <div>预计评级: <span :class="gradeColor(calculatedGrade)" class="font-bold text-2xl px-2 py-1 rounded">
                        {{ calculatedGrade }}
                    </span></div>
                </div>
                
                <div class="flex gap-2">
                    <button @click="submitRating" class="flex-1 bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">提交</button>
                    <button @click="showRating=false" class="flex-1 bg-gray-300 px-4 py-2 rounded hover:bg-gray-400">取消</button>
                </div>
            </div>
        </div>
    </div>

    <script>
    const { createApp } = Vue;
    
    createApp({
        data() {
            return {
                stats: {},
                scripts: [],
                filter: 'all',
                showRating: false,
                currentScript: {},
                rating: {
                    content_score: 80,
                    market_score: 80,
                    commercial_score: 80,
                    compliance_score: 90,
                    comments: ''
                }
            }
        },
        computed: {
            calculatedScore() {
                const { content_score, market_score, commercial_score, compliance_score } = this.rating;
                if (compliance_score < 60) return 0;
                return (content_score * 0.4 + market_score * 0.3 + commercial_score * 0.3).toFixed(1);
            },
            calculatedGrade() {
                const score = parseFloat(this.calculatedScore);
                if (this.rating.compliance_score < 60) return 'D';
                if (score >= 90) return 'S';
                if (score >= 80) return 'A';
                if (score >= 70) return 'B';
                if (score >= 60) return 'C';
                return 'D';
            }
        },
        methods: {
            async loadData() {
                try {
                    const stats = await axios.get('/api/stats');
                    this.stats = stats.data;
                    
                    const scripts = await axios.get('/api/scripts', {
                        params: this.filter !== 'all' ? { quickFilter: this.filter } : {}
                    });
                    this.scripts = scripts.data;
                    
                    this.renderChart();
                } catch (error) {
                    console.error('加载数据失败:', error);
                }
            },
            renderChart() {
                const chart = echarts.init(document.getElementById('chart'));
                const option = {
                    title: { text: '评级分布' },
                    tooltip: {},
                    xAxis: {
                        data: this.stats.grade_distribution?.map(g => g.grade) || []
                    },
                    yAxis: {},
                    series: [{
                        name: '数量',
                        type: 'bar',
                        data: this.stats.grade_distribution?.map(g => g.count) || [],
                        itemStyle: {
                            color: function(params) {
                                const colors = { S: '#722ED1', A: '#0FC6C2', B: '#00B42A', C: '#FF7D00', D: '#F53F3F' };
                                return colors[params.name] || '#1890ff';
                            }
                        }
                    }]
                };
                chart.setOption(option);
            },
            buttonClass(f) {
                return this.filter === f ? 'bg-blue-500 text-white' : 'bg-gray-200';
            },
            gradeColor(grade) {
                const colors = {
                    S: 'bg-purple-500 text-white',
                    A: 'bg-cyan-500 text-white',
                    B: 'bg-green-500 text-white',
                    C: 'bg-orange-500 text-white',
                    D: 'bg-red-500 text-white'
                };
                return colors[grade] || 'bg-gray-300';
            },
            preview(script) {
                if (script.file_url) {
                    window.open(script.file_url, '_blank');
                } else {
                    alert('未配置飞书文档链接');
                }
            },
            rate(script) {
                this.currentScript = script;
                this.showRating = true;
                this.rating = {
                    content_score: 80,
                    market_score: 80,
                    commercial_score: 80,
                    compliance_score: 90,
                    comments: ''
                };
            },
            async submitRating() {
                try {
                    await axios.post(\`/api/scripts/\${this.currentScript.script_id}/ratings\`, this.rating);
                    alert('评分提交成功');
                    this.showRating = false;
                    this.loadData();
                } catch (error) {
                    alert('评分提交失败: ' + error.message);
                }
            },
            async deleteScript(script) {
                if (!confirm(\`确认删除剧本《\${script.name}》吗？此操作不可恢复！\`)) return;
                try {
                    await axios.delete(\`/api/scripts/\${script.script_id}\`);
                    alert('删除成功');
                    this.loadData();
                } catch (error) {
                    alert('删除失败: ' + error.message);
                }
            }
        },
        watch: {
            filter() {
                this.loadData();
            }
        },
        mounted() {
            this.loadData();
        }
    }).mount('#app');
    </script>
</body>
</html>
  `)
})

export default app
