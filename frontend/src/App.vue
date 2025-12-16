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
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
              <h2 class="page-title">
                <icon-dashboard />
                数据看板
              </h2>
              <a-button type="primary" @click="refreshData">
                <template #icon><icon-refresh /></template>
                刷新数据
              </a-button>
            </div>

            <a-spin :loading="dashboardLoading" style="width: 100%;">
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
                      :precision="2"
                      :value-style="{ color: '#722ED1', fontSize: '32px', fontWeight: 'bold' }"
                    >
                      <template #prefix>
                        <icon-star :size="24" />
                      </template>
                    </a-statistic>
                  </a-card>
                </a-col>
              </a-row>

              <!-- 图表 -->
              <a-row :gutter="16">
                <a-col :span="8">
                  <a-card title="📊 评级漏斗" class="chart-card">
                    <div ref="gradeChart" style="height: 300px;"></div>
                  </a-card>
                </a-col>
                <a-col :span="8">
                  <a-card title="🎯 来源分析" class="chart-card">
                    <div ref="sourceChart" style="height: 300px;"></div>
                  </a-card>
                </a-col>
                <a-col :span="8">
                  <a-card title="📈 状态分布" class="chart-card">
                    <div ref="statusChart" style="height: 300px;"></div>
                  </a-card>
                </a-col>
              </a-row>
            </a-spin>
          </div>

          <!-- 剧本管理 -->
          <div v-if="currentPage === 'scripts'" class="page">
            <h2 class="page-title">
              <icon-book />
              剧本管理
            </h2>

            <!-- 快捷筛选 -->
            <a-card class="filter-card">
              <a-space size="medium">
                <a-button 
                  :type="quickFilter === 'all' ? 'primary' : 'outline'"
                  @click="quickFilter = 'all'"
                >
                  全部 ({{ getTabCount('all') }})
                </a-button>
                <a-button 
                  :type="quickFilter === 'pending' ? 'primary' : 'outline'"
                  @click="quickFilter = 'pending'"
                >
                  待评分 ({{ getTabCount('pending') }})
                </a-button>
                <a-button 
                  :type="quickFilter === 'sLevel' ? 'primary' : 'outline'"
                  @click="quickFilter = 'sLevel'"
                >
                  S级潜力 ({{ getTabCount('sLevel') }})
                </a-button>
                <a-button 
                  :type="quickFilter === 'project' ? 'primary' : 'outline'"
                  @click="quickFilter = 'project'"
                >
                  已立项 ({{ getTabCount('project') }})
                </a-button>
                <a-button @click="refreshData">
                  <template #icon><icon-refresh /></template>
                  刷新
                </a-button>
              </a-space>
            </a-card>

            <!-- 搜索和高级筛选 -->
            <a-card class="search-card">
              <a-row :gutter="16">
                <a-col :span="8">
                  <a-input-search 
                    v-model="searchText" 
                    placeholder="搜索剧本名称或编号"
                    allow-clear
                  />
                </a-col>
                <a-col :span="5">
                  <a-select 
                    v-model="filterStatus" 
                    placeholder="状态筛选"
                    allow-clear
                  >
                    <a-option 
                      v-for="status in statusOptions" 
                      :key="status" 
                      :value="status"
                    >
                      {{ status }}
                    </a-option>
                  </a-select>
                </a-col>
                <a-col :span="5">
                  <a-select 
                    v-model="filterSource" 
                    placeholder="来源筛选"
                    allow-clear
                  >
                    <a-option 
                      v-for="source in sourceOptions" 
                      :key="source" 
                      :value="source"
                    >
                      {{ source }}
                    </a-option>
                  </a-select>
                </a-col>
                <a-col :span="6">
                  <a-space>
                    <a-button @click="resetFilters">重置筛选</a-button>
                  </a-space>
                </a-col>
              </a-row>
            </a-card>

            <!-- 数据表格 -->
            <a-card>
              <a-table 
                :columns="columns" 
                :data="filteredScripts"
                :loading="loading"
                :pagination="{ pageSize: 10 }"
              >
                <template #scriptId="{ record }">
                  <a-tag color="blue">{{ record.scriptId }}</a-tag>
                </template>
                
                <template #grade="{ record }">
                  <a-tag v-if="record.grade" :color="getGradeColor(record.grade)">
                    {{ record.grade }}
                  </a-tag>
                  <span v-else style="color: #86909c;">未评分</span>
                </template>
                
                <template #totalScore="{ record }">
                  <span v-if="record.totalScore" style="font-weight: 600;">
                    {{ record.totalScore }}
                  </span>
                  <span v-else style="color: #86909c;">-</span>
                </template>
                
                <template #tags="{ record }">
                  <a-space>
                    <a-tag 
                      v-for="tag in parseTags(record.tags)" 
                      :key="tag"
                      :color="getTagColor(tag)"
                      size="small"
                    >
                      {{ tag }}
                    </a-tag>
                  </a-space>
                </template>
                
                <template #isProject="{ record }">
                  <a-tag v-if="record.isProject" color="green">
                    <template #icon><icon-check /></template>
                    已立项
                  </a-tag>
                  <span v-else style="color: #86909c;">-</span>
                </template>
                
                <template #operations="{ record }">
                  <a-space>
                    <a-button type="text" size="small">
                      <template #icon><icon-eye /></template>
                      查看
                    </a-button>
                    <a-button type="text" size="small" status="success">
                      <template #icon><icon-edit /></template>
                      评分
                    </a-button>
                    <a-button 
                      type="text" 
                      size="small" 
                      status="danger"
                      @click="handleDelete(record.scriptId)"
                    >
                      <template #icon><icon-delete /></template>
                      删除
                    </a-button>
                  </a-space>
                </template>
              </a-table>
            </a-card>
          </div>

          <!-- 剧本排行 -->
          <div v-if="currentPage === 'leaderboard'" class="page">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
              <h2 class="page-title">
                <icon-trophy />
                剧本排行榜 Top 10
              </h2>
              <a-button type="primary" @click="refreshData">
                <template #icon><icon-refresh /></template>
                刷新
              </a-button>
            </div>

            <a-card>
              <a-table 
                :columns="leaderboardColumns" 
                :data="leaderboardData"
                :loading="loading"
                :pagination="false"
              >
                <template #rank="{ rowIndex }">
                  <div class="rank-badge" :class="`rank-${rowIndex + 1}`">
                    {{ rowIndex + 1 }}
                  </div>
                </template>
                
                <template #name="{ record }">
                  <div style="font-weight: 600;">{{ record.name }}</div>
                  <div style="font-size: 12px; color: #86909c;">{{ record.scriptId }}</div>
                </template>
                
                <template #grade="{ record }">
                  <a-tag :color="getGradeColor(record.grade)" size="large">
                    {{ record.grade }}
                  </a-tag>
                </template>
                
                <template #totalScore="{ record }">
                  <span style="font-size: 18px; font-weight: bold; color: #165DFF;">
                    {{ record.totalScore }}
                  </span>
                </template>
                
                <template #tags="{ record }">
                  <a-space wrap>
                    <a-tag 
                      v-for="tag in parseTags(record.tags)" 
                      :key="tag"
                      :color="getTagColor(tag)"
                    >
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

// 导入API
import { getStats, getScripts, getRankings, deleteScript } from './api/index.js'

// 当前页面
const currentPage = ref('dashboard')

// 加载状态
const loading = ref(false)
const dashboardLoading = ref(false)

// 统计数据
const stats = ref({
  totalScripts: 0,
  projectCount: 0,
  pendingRating: 0,
  conversionRate: 0,
  avgScore: 0
})

// 数据
const scripts = ref([])
const leaderboardData = ref([])

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

// ==================== API调用函数 ====================

// 加载统计数据
const loadStats = async () => {
  try {
    dashboardLoading.value = true
    console.log('正在加载统计数据...')
    const data = await getStats()
    console.log('统计数据:', data)
    
    stats.value = {
      totalScripts: data.totalScripts || 0,
      projectCount: data.totalProjects || 0,
      pendingRating: data.pendingRatings || 0,
      conversionRate: data.conversionRate || 0,
      avgScore: data.averageScore || 0
    }
    
    // 刷新图表
    nextTick(() => {
      initCharts()
    })
  } catch (error) {
    console.error('加载统计数据失败:', error)
  } finally {
    dashboardLoading.value = false
  }
}

// 加载剧本列表
const loadScripts = async () => {
  try {
    loading.value = true
    console.log('正在加载剧本列表...')
    const data = await getScripts()
    console.log('剧本列表:', data)
    
    scripts.value = data || []
  } catch (error) {
    console.error('加载剧本列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 加载排行榜
const loadLeaderboard = async () => {
  try {
    loading.value = true
    console.log('正在加载排行榜...')
    const data = await getRankings(10)
    console.log('排行榜数据:', data)
    
    leaderboardData.value = data || []
  } catch (error) {
    console.error('加载排行榜失败:', error)
  } finally {
    loading.value = false
  }
}

// 刷新当前页面数据
const refreshData = async () => {
  console.log('刷新数据，当前页面:', currentPage.value)
  if (currentPage.value === 'dashboard') {
    await loadStats()
  } else if (currentPage.value === 'scripts') {
    await loadScripts()
  } else if (currentPage.value === 'leaderboard') {
    await loadLeaderboard()
  }
}

// 删除剧本
const handleDelete = async (scriptId) => {
  try {
    console.log('删除剧本:', scriptId)
    await deleteScript(scriptId)
    console.log('删除成功')
    await loadScripts()
  } catch (error) {
    console.error('删除失败:', error)
  }
}

// ==================== 辅助函数 ====================

const parseTags = (tags) => {
  try {
    if (Array.isArray(tags)) return tags
    if (typeof tags === 'string') {
      return JSON.parse(tags)
    }
    return []
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

const getTabCount = (tab) => {
  if (tab === 'all') return scripts.value.length
  if (tab === 'pending') return scripts.value.filter(s => !s.grade).length
  if (tab === 'sLevel') return scripts.value.filter(s => s.grade === 'S').length
  if (tab === 'project') return scripts.value.filter(s => s.isProject).length
  return 0
}

const filteredScripts = computed(() => {
  let result = [...scripts.value]
  
  // 快捷筛选
  if (quickFilter.value === 'pending') {
    result = result.filter(s => !s.grade)
  } else if (quickFilter.value === 'sLevel') {
    result = result.filter(s => s.grade === 'S')
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

const handleMenuClick = async (key) => {
  console.log('切换菜单:', key)
  currentPage.value = key
  
  // 切换页面时加载对应数据
  if (key === 'dashboard') {
    await loadStats()
  } else if (key === 'scripts') {
    await loadScripts()
  } else if (key === 'leaderboard') {
    await loadLeaderboard()
  }
}

// 图表
const gradeChart = ref(null)
const sourceChart = ref(null)
const statusChart = ref(null)

const initCharts = () => {
  console.log('初始化图表...')
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
      grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
      xAxis: {
        type: 'category',
        data: ['内部团队', '外部投稿', '合作编剧', '版权采购'],
        axisLabel: { rotate: 0, fontSize: 12 }
      },
      yAxis: { type: 'value' },
      series: [{
        type: 'bar',
        data: [14, 6, 6, 4],
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
      grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
      xAxis: {
        type: 'category',
        data: ['一卡初稿', '改稿中', '完整剧本', '终稿(已立项)'],
        axisLabel: { rotate: 20, fontSize: 12 }
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

// 组件挂载时加载数据
onMounted(async () => {
  console.log('App 组件已挂载，开始加载数据...')
  await loadStats()
  await loadScripts()
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
