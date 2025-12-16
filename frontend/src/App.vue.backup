<template>
  <div id="app">
    <a-layout class="layout">
      <!-- 顶部导航 -->
      <a-layout-header class="header">
        <div class="header-content">
          <div class="logo">
            <icon-star />
            <span class="logo-text">DeepDrama</span>
            <span class="subtitle">剧本管理系统</span>
          </div>
          <div class="user-info">
            <a-avatar>
              <icon-user />
            </a-avatar>
            <span class="username">管理员</span>
          </div>
        </div>
      </a-layout-header>

      <a-layout>
        <!-- 侧边栏 -->
        <a-layout-sider :width="220" class="sider">
          <a-menu :default-selected-keys="['dashboard']" @menu-item-click="handleMenuClick">
            <a-menu-item key="dashboard">
              <icon-dashboard />
              数据看板
            </a-menu-item>
            <a-menu-item key="scripts">
              <icon-book />
              剧本管理
            </a-menu-item>
            <a-menu-item key="leaderboard">
              <icon-trophy />
              剧本排行
            </a-menu-item>
          </a-menu>
        </a-layout-sider>

        <!-- 主内容区 -->
        <a-layout-content class="content">
          <!-- 数据看板 -->
          <div v-if="currentPage === 'dashboard'" class="page">
            <h2 class="page-title">
              <icon-dashboard />
              数据看板
            </h2>

            <!-- KPI卡片 -->
            <a-row :gutter="16" class="kpi-row">
              <a-col :span="6">
                <a-card class="kpi-card kpi-blue">
                  <a-statistic 
                    title="剧本总库" 
                    :value="stats.totalScripts"
                    :value-style="{ color: '#165DFF', fontSize: '32px', fontWeight: 'bold' }"
                  >
                    <template #prefix>
                      <icon-book :size="24" />
                    </template>
                  </a-statistic>
                </a-card>
              </a-col>
              <a-col :span="6">
                <a-card class="kpi-card kpi-green">
                  <a-statistic 
                    title="立项转化率" 
                    :value="stats.conversionRate"
                    suffix="%"
                    :value-style="{ color: '#00B42A', fontSize: '32px', fontWeight: 'bold' }"
                  >
                    <template #prefix>
                      <icon-check :size="24" />
                    </template>
                  </a-statistic>
                </a-card>
              </a-col>
              <a-col :span="6">
                <a-card class="kpi-card kpi-orange">
                  <a-statistic 
                    title="待办积压" 
                    :value="stats.pendingRating"
                    :value-style="{ color: '#FF7D00', fontSize: '32px', fontWeight: 'bold' }"
                  >
                    <template #prefix>
                      <span style="font-size: 24px;">⏰</span>
                    </template>
                  </a-statistic>
                </a-card>
              </a-col>
              <a-col :span="6">
                <a-card class="kpi-card kpi-purple">
                  <a-statistic 
                    title="平均质量分" 
                    :value="stats.avgScore"
                    :value-style="{ color: '#722ED1', fontSize: '32px', fontWeight: 'bold' }"
                  >
                    <template #prefix>
                      <icon-star :size="24" />
                    </template>
                  </a-statistic>
                </a-card>
              </a-col>
            </a-row>

            <!-- 图表区域 -->
            <a-row :gutter="16" style="margin-top: 16px;">
              <a-col :span="8">
                <a-card title="评级漏斗" :bordered="true">
                  <div ref="gradeChart" style="height: 300px;"></div>
                </a-card>
              </a-col>
              <a-col :span="8">
                <a-card title="来源分析" :bordered="true">
                  <div ref="sourceChart" style="height: 300px;"></div>
                </a-card>
              </a-col>
              <a-col :span="8">
                <a-card title="状态分布" :bordered="true">
                  <div ref="statusChart" style="height: 300px;"></div>
                </a-card>
              </a-col>
            </a-row>
          </div>

          <!-- 剧本管理 -->
          <div v-if="currentPage === 'scripts'" class="page">
            <h2 class="page-title">
              <icon-book />
              剧本管理
            </h2>

            <!-- 快捷筛选 -->
            <a-radio-group v-model="quickFilter" type="button" class="quick-filter">
              <a-radio value="all">全部 ({{ getTabCount('all') }})</a-radio>
              <a-radio value="pending">待评分 ({{ getTabCount('pending') }})</a-radio>
              <a-radio value="sLevel">S级潜力 ({{ getTabCount('sLevel') }})</a-radio>
              <a-radio value="project">已立项 ({{ getTabCount('project') }})</a-radio>
            </a-radio-group>

            <!-- 筛选工具栏 -->
            <a-card style="margin: 16px 0;">
              <a-space size="medium">
                <a-input-search
                  v-model="searchText"
                  placeholder="搜索剧本名称或编号"
                  style="width: 300px;"
                />
                <a-select v-model="filterStatus" placeholder="全部状态" style="width: 150px;" allow-clear>
                  <a-option value="">全部状态</a-option>
                  <a-option v-for="s in statusOptions" :key="s" :value="s">{{ s }}</a-option>
                </a-select>
                <a-select v-model="filterSource" placeholder="全部来源" style="width: 150px;" allow-clear>
                  <a-option value="">全部来源</a-option>
                  <a-option v-for="s in sourceOptions" :key="s" :value="s">{{ s }}</a-option>
                </a-select>
                <a-button @click="resetFilters">
                  <template #icon><icon-refresh /></template>
                  重置
                </a-button>
                <a-button type="primary">
                  <template #icon><icon-plus /></template>
                  新增剧本
                </a-button>
              </a-space>
            </a-card>

            <!-- 剧本表格 -->
            <a-card>
              <a-table 
                :columns="columns" 
                :data="filteredScripts"
                :pagination="{ pageSize: 10 }"
              >
                <template #scriptId="{ record }">
                  <span class="mono-font">{{ record.scriptId }}</span>
                </template>
                <template #grade="{ record }">
                  <a-tag v-if="getLatestRating(record)" 
                         :color="getGradeColor(getLatestRating(record).grade)">
                    {{ getLatestRating(record).grade }}
                  </a-tag>
                  <span v-else style="color: #999;">待评分</span>
                </template>
                <template #totalScore="{ record }">
                  <span v-if="getLatestRating(record)" class="score-text">
                    {{ getLatestRating(record).totalScore }}
                  </span>
                  <span v-else style="color: #999;">-</span>
                </template>
                <template #tags="{ record }">
                  <a-space>
                    <a-tag v-for="tag in parseTags(record.tags)" 
                           :key="tag" 
                           :color="getTagColor(tag)">
                      {{ tag }}
                    </a-tag>
                  </a-space>
                </template>
                <template #isProject="{ record }">
                  <a-tag v-if="record.isProject" color="green">
                    <icon-check />已立项
                  </a-tag>
                  <span v-else style="color: #999;">-</span>
                </template>
                <template #operations="{ record }">
                  <a-space>
                    <a-button type="text" size="small">
                      <icon-eye />
                    </a-button>
                    <a-button type="text" size="small">
                      <icon-star />
                    </a-button>
                    <a-button type="text" size="small">
                      <icon-edit />
                    </a-button>
                    <a-button type="text" size="small" status="danger">
                      <icon-delete />
                    </a-button>
                  </a-space>
                </template>
              </a-table>
            </a-card>
          </div>

          <!-- 剧本排行 -->
          <div v-if="currentPage === 'leaderboard'" class="page">
            <h2 class="page-title">
              <icon-trophy />
              剧本排行
            </h2>

            <a-card>
              <a-table 
                :columns="leaderboardColumns" 
                :data="leaderboard"
                :pagination="false"
              >
                <template #rank="{ rowIndex }">
                  <span v-if="rowIndex === 0" style="font-size: 24px;">🥇</span>
                  <span v-else-if="rowIndex === 1" style="font-size: 24px;">🥈</span>
                  <span v-else-if="rowIndex === 2" style="font-size: 24px;">🥉</span>
                  <span v-else class="rank-number">{{ rowIndex + 1 }}</span>
                </template>
                <template #name="{ record }">
                  <div>
                    <div class="script-name">{{ record.name }}</div>
                    <div v-if="record.grade === 'S'" class="hot-label">
                      🔥 爆款预测
                    </div>
                  </div>
                </template>
                <template #grade="{ record }">
                  <a-tag :color="getGradeColor(record.grade)" style="font-size: 14px; padding: 4px 12px;">
                    {{ record.grade }}级
                  </a-tag>
                </template>
                <template #totalScore="{ record }">
                  <span class="score-large">{{ record.totalScore }}</span>
                </template>
                <template #tags="{ record }">
                  <a-space>
                    <a-tag v-for="tag in parseTags(record.tags)" 
                           :key="tag" 
                           :color="getTagColor(tag)">
                      {{ tag }}
                    </a-tag>
                  </a-space>
                </template>
              </a-table>
            </a-card>
          </div>
        </a-layout-content>
      </a-layout>
    </a-layout>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import * as echarts from 'echarts'
import {
  IconDashboard, IconBook, IconTrophy, IconUser,
  IconStar, IconRefresh, IconPlus,
  IconEye, IconEdit, IconDelete, IconCheck
} from '@arco-design/web-vue/es/icon'

// 当前页面
const currentPage = ref('dashboard')

// 统计数据
const stats = ref({
  totalScripts: 30,
  projectCount: 8,
  pendingRating: 7,
  conversionRate: '26.7',
  avgScore: '82.67'
})

// 模拟数据
const mockScripts = [
  { id: 1, scriptId: 'SP001', name: '总裁的替嫁甜妻', tags: '["女频","甜宠","付费"]', sourceType: '内部团队', team: 'A组编剧团', status: '完整剧本', isProject: true },
  { id: 2, scriptId: 'SP002', name: '重生之商业帝国', tags: '["男频","商战","付费"]', sourceType: '内部团队', team: 'B组编剧团', status: '终稿(已立项)', isProject: true },
  { id: 3, scriptId: 'SP003', name: '闪婚老公是大佬', tags: '["女频","甜宠","爆款引擎"]', sourceType: '外部投稿', team: null, status: '改稿中', isProject: false },
  { id: 4, scriptId: 'SP004', name: '战神归来', tags: '["男频","都市","免费"]', sourceType: '合作编剧', team: 'C组编剧团', status: '一卡初稿', isProject: false },
  { id: 5, scriptId: 'SP005', name: '豪门弃妇逆袭记', tags: '["女频","复仇","付费"]', sourceType: '内部团队', team: 'A组编剧团', status: '完整剧本', isProject: true },
  { id: 6, scriptId: 'SP006', name: '穿越之农门医女', tags: '["女频","穿越","免费"]', sourceType: '版权采购', team: null, status: '改稿中', isProject: false },
  { id: 7, scriptId: 'SP007', name: '神豪系统', tags: '["男频","系统","付费"]', sourceType: '内部团队', team: 'B组编剧团', status: '一卡初稿', isProject: false },
  { id: 8, scriptId: 'SP008', name: '冷面王爷的心尖宠', tags: '["女频","古言","爆款引擎"]', sourceType: '外部投稿', team: null, status: '完整剧本', isProject: false },
  { id: 9, scriptId: 'SP009', name: '龙王殿', tags: '["男频","都市","付费"]', sourceType: '合作编剧', team: 'A组编剧团', status: '终稿(已立项)', isProject: true },
  { id: 10, scriptId: 'SP010', name: '全能女神', tags: '["女频","职场","免费"]', sourceType: '内部团队', team: 'C组编剧团', status: '改稿中', isProject: false }
]

const mockRatings = [
  { scriptId: 'SP001', totalScore: 91.7, grade: 'S' },
  { scriptId: 'SP002', totalScore: 92.9, grade: 'S' },
  { scriptId: 'SP003', totalScore: 85.4, grade: 'A' },
  { scriptId: 'SP004', totalScore: 76.1, grade: 'B' },
  { scriptId: 'SP005', totalScore: 91.6, grade: 'S' },
  { scriptId: 'SP006', totalScore: 75.8, grade: 'B' },
  { scriptId: 'SP008', totalScore: 85.7, grade: 'A' },
  { scriptId: 'SP009', totalScore: 90.5, grade: 'S' },
  { scriptId: 'SP010', totalScore: 67.1, grade: 'C' }
]

const scripts = ref(mockScripts)
const ratings = ref(mockRatings)

// 筛选
const quickFilter = ref('all')
const searchText = ref('')
const filterStatus = ref('')
const filterSource = ref('')

const statusOptions = ['一卡初稿', '改稿中', '完整剧本', '终稿(已立项)']
const sourceOptions = ['内部团队', '外部投稿', '合作编剧', '版权采购']

// 表格列
const columns = [
  { title: '编号', slotName: 'scriptId', width: 100 },
  { title: '剧本名称', dataIndex: 'name', width: 200 },
  { title: '评级', slotName: 'grade', width: 80, align: 'center' },
  { title: '总分', slotName: 'totalScore', width: 80, align: 'center' },
  { title: '标签', slotName: 'tags', width: 200 },
  { title: '来源', dataIndex: 'sourceType', width: 120 },
  { title: '团队', dataIndex: 'team', width: 120 },
  { title: '状态', dataIndex: 'status', width: 120 },
  { title: '立项', slotName: 'isProject', width: 100, align: 'center' },
  { title: '操作', slotName: 'operations', width: 180, align: 'center' }
]

const leaderboardColumns = [
  { title: '排名', slotName: 'rank', width: 80, align: 'center' },
  { title: '剧本名称', slotName: 'name', width: 250 },
  { title: '评级', slotName: 'grade', width: 100, align: 'center' },
  { title: '总分', slotName: 'totalScore', width: 100, align: 'center' },
  { title: '标签', slotName: 'tags' }
]

// 排行榜数据
const leaderboard = computed(() => {
  return scripts.value
    .map(s => ({
      ...s,
      ...getLatestRating(s)
    }))
    .filter(s => s.totalScore)
    .sort((a, b) => b.totalScore - a.totalScore)
    .slice(0, 10)
})

// 辅助函数
const parseTags = (tags) => {
  try {
    return JSON.parse(tags || '[]')
  } catch {
    return []
  }
}

const getTagColor = (tag) => {
  const colorMap = {
    '男频': 'blue',
    '女频': 'pink',
    '付费': 'gold',
    '免费': 'green',
    '爆款引擎': 'red',
    '甜宠': 'magenta',
    '复仇': 'volcano',
    '都市': 'cyan',
    '穿越': 'purple',
    '古言': 'geekblue'
  }
  return colorMap[tag] || 'gray'
}

const getGradeColor = (grade) => {
  const colorMap = {
    'S': 'purple',
    'A': 'cyan',
    'B': 'green',
    'C': 'orange',
    'D': 'red'
  }
  return colorMap[grade] || 'gray'
}

const getLatestRating = (script) => {
  return ratings.value.find(r => r.scriptId === script.scriptId)
}

const getTabCount = (tab) => {
  if (tab === 'all') return scripts.value.length
  if (tab === 'pending') return scripts.value.filter(s => !getLatestRating(s)).length
  if (tab === 'sLevel') return scripts.value.filter(s => {
    const r = getLatestRating(s)
    return r && r.totalScore >= 90
  }).length
  if (tab === 'project') return scripts.value.filter(s => s.isProject).length
  return 0
}

const filteredScripts = computed(() => {
  let result = [...scripts.value]
  
  // 快捷筛选
  if (quickFilter.value === 'pending') {
    result = result.filter(s => !getLatestRating(s))
  } else if (quickFilter.value === 'sLevel') {
    result = result.filter(s => {
      const r = getLatestRating(s)
      return r && r.totalScore >= 90
    })
  } else if (quickFilter.value === 'project') {
    result = result.filter(s => s.isProject)
  }
  
  // 搜索
  if (searchText.value) {
    const search = searchText.value.toLowerCase()
    result = result.filter(s => 
      s.name.toLowerCase().includes(search) || 
      s.scriptId.toLowerCase().includes(search)
    )
  }
  
  // 状态筛选
  if (filterStatus.value) {
    result = result.filter(s => s.status === filterStatus.value)
  }
  
  // 来源筛选
  if (filterSource.value) {
    result = result.filter(s => s.sourceType === filterSource.value)
  }
  
  return result
})

const resetFilters = () => {
  searchText.value = ''
  filterStatus.value = ''
  filterSource.value = ''
  quickFilter.value = 'all'
}

const handleMenuClick = (key) => {
  currentPage.value = key
  if (key === 'dashboard') {
    nextTick(() => {
      initCharts()
    })
  }
}

// 图表
const gradeChart = ref(null)
const sourceChart = ref(null)
const statusChart = ref(null)

const initCharts = () => {
  // 评级漏斗
  if (gradeChart.value) {
    const chart1 = echarts.init(gradeChart.value)
    chart1.setOption({
      tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
      legend: { bottom: 10, left: 'center' },
      series: [{
        type: 'pie',
        radius: ['40%', '70%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 10,
          borderColor: '#fff',
          borderWidth: 2
        },
        label: { show: false },
        emphasis: {
          label: { show: true, fontSize: 16, fontWeight: 'bold' }
        },
        data: [
          { name: 'S级', value: 5, itemStyle: { color: '#722ED1' } },
          { name: 'A级', value: 10, itemStyle: { color: '#0FC6C2' } },
          { name: 'B级', value: 5, itemStyle: { color: '#00B42A' } },
          { name: 'C级', value: 2, itemStyle: { color: '#FF7D00' } },
          { name: 'D级', value: 1, itemStyle: { color: '#F53F3F' } }
        ]
      }]
    })
  }
  
  // 来源分析
  if (sourceChart.value) {
    const chart2 = echarts.init(sourceChart.value)
    chart2.setOption({
      tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
      xAxis: {
        type: 'category',
        data: ['内部团队', '外部投稿', '合作编剧', '版权采购'],
        axisLabel: { interval: 0, rotate: 15 }
      },
      yAxis: { type: 'value' },
      series: [{
        type: 'bar',
        data: [13, 6, 6, 5],
        itemStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#3B82F6' },
            { offset: 1, color: '#1D4ED8' }
          ])
        },
        barWidth: 30
      }]
    })
  }
  
  // 状态分布
  if (statusChart.value) {
    const chart3 = echarts.init(statusChart.value)
    chart3.setOption({
      tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
      xAxis: {
        type: 'category',
        data: ['一卡初稿', '改稿中', '完整剧本', '终稿(已立项)'],
        axisLabel: { interval: 0, rotate: 15 }
      },
      yAxis: { type: 'value' },
      series: [{
        type: 'bar',
        data: [8, 8, 10, 4],
        itemStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#10B981' },
            { offset: 1, color: '#059669' }
          ])
        },
        barWidth: 30
      }]
    })
  }
}

onMounted(() => {
  nextTick(() => {
    initCharts()
  })
})
</script>

<style scoped>
* {
  box-sizing: border-box;
}

.layout {
  min-height: 100vh;
}

.header {
  background: #1d2129;
  padding: 0;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 24px;
  height: 100%;
}

.logo {
  display: flex;
  align-items: center;
  gap: 12px;
  color: #fff;
  font-size: 20px;
  font-weight: bold;
}

.logo-text {
  font-size: 20px;
}

.subtitle {
  font-size: 14px;
  color: #86909c;
  font-weight: normal;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #fff;
}

.username {
  font-size: 14px;
}

.sider {
  background: #fff;
  border-right: 1px solid #e5e6eb;
}

.content {
  background: #f2f3f5;
  padding: 24px;
  min-height: calc(100vh - 60px);
}

.page {
  min-height: 100%;
}

.page-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 20px;
  margin-bottom: 16px;
  color: #1d2129;
}

.kpi-row {
  margin-bottom: 16px;
}

.kpi-card {
  border-radius: 8px;
  border: 1px solid #e5e6eb;
}

.kpi-blue {
  background: linear-gradient(135deg, #e8f4ff 0%, #f0f9ff 100%);
}

.kpi-green {
  background: linear-gradient(135deg, #e8f8f0 0%, #f0fdf4 100%);
}

.kpi-orange {
  background: linear-gradient(135deg, #fff3e6 0%, #fffbf0 100%);
}

.kpi-purple {
  background: linear-gradient(135deg, #f3e8ff 0%, #faf5ff 100%);
}

.quick-filter {
  margin-bottom: 16px;
}

.mono-font {
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-weight: 600;
  color: #165DFF;
}

.score-text {
  font-size: 16px;
  font-weight: bold;
  color: #165DFF;
}

.score-large {
  font-size: 20px;
  font-weight: bold;
  color: #165DFF;
}

.rank-number {
  font-size: 18px;
  font-weight: bold;
  color: #4e5969;
}

.script-name {
  font-weight: 500;
  color: #1d2129;
  margin-bottom: 4px;
}

.hot-label {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  color: #f53f3f;
  font-size: 12px;
  font-weight: 500;
}
</style>
