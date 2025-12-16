// 新版 App.vue 的 script 部分 - 调用真实API
import { ref, computed, onMounted, nextTick } from 'vue'
import * as echarts from 'echarts'
import {
  IconDashboard, IconBook, IconTrophy, IconUser,
  IconStar, IconRefresh, IconPlus,
  IconEye, IconEdit, IconDelete, IconCheck
} from '@arco-design/web-vue/es/icon'

// 导入API
import { getStats, getScripts, getRankings, submitRating, deleteScript } from './api/index.js'

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
const ratings = ref([])
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
    window.$message?.error('加载统计数据失败')
  } finally {
    dashboardLoading.value = false
  }
}

// 加载剧本列表
const loadScripts = async () => {
  try {
    loading.value = true
    const data = await getScripts()
    console.log('剧本列表:', data)
    
    scripts.value = data || []
  } catch (error) {
    console.error('加载剧本列表失败:', error)
    window.$message?.error('加载剧本列表失败')
  } finally {
    loading.value = false
  }
}

// 加载排行榜
const loadLeaderboard = async () => {
  try {
    loading.value = true
    const data = await getRankings(10)
    console.log('排行榜数据:', data)
    
    leaderboardData.value = data || []
  } catch (error) {
    console.error('加载排行榜失败:', error)
    window.$message?.error('加载排行榜失败')
  } finally {
    loading.value = false
  }
}

// 刷新当前页面数据
const refreshData = async () => {
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
    await deleteScript(scriptId)
    window.$message?.success('删除成功')
    await loadScripts()
  } catch (error) {
    console.error('删除失败:', error)
    window.$message?.error('删除失败')
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

const getLatestRating = (script) => {
  // 从脚本对象中获取评分信息
  if (script.totalScore && script.grade) {
    return {
      totalScore: script.totalScore,
      grade: script.grade
    }
  }
  return null
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

export default {
  components: {
    IconDashboard, IconBook, IconTrophy, IconUser,
    IconStar, IconRefresh, IconPlus,
    IconEye, IconEdit, IconDelete, IconCheck
  },
  setup() {
    return {
      // 状态
      currentPage,
      loading,
      dashboardLoading,
      stats,
      scripts,
      ratings,
      leaderboardData,
      
      // 筛选
      quickFilter,
      searchText,
      filterStatus,
      filterSource,
      statusOptions,
      sourceOptions,
      
      // 表格
      columns,
      leaderboardColumns,
      filteredScripts,
      
      // 方法
      loadStats,
      loadScripts,
      loadLeaderboard,
      refreshData,
      handleDelete,
      parseTags,
      getTagColor,
      getGradeColor,
      getLatestRating,
      getTabCount,
      resetFilters,
      handleMenuClick,
      
      // 图表
      gradeChart,
      sourceChart,
      statusChart,
      initCharts
    }
  }
}
