import axios from 'axios'

// API基础地址 - 自动检测后端地址
// 开发环境：使用环境变量或当前主机
// 生产环境：使用实际部署的后端地址
const getBaseURL = () => {
  // 优先使用环境变量配置的后端地址
  if (import.meta.env.VITE_API_BASE_URL) {
    return import.meta.env.VITE_API_BASE_URL
  }
  
  // 如果前端和后端在同一台机器，使用当前主机地址
  if (window.location.hostname !== 'localhost' && window.location.hostname !== '127.0.0.1') {
    return `http://${window.location.hostname}:8080`
  }
  
  // 默认使用localhost
  return 'http://localhost:8080'
}

const BASE_URL = getBaseURL()

console.log('API Base URL:', BASE_URL)

// 创建axios实例
const request = axios.create({
  baseURL: BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器
request.interceptors.request.use(
  config => {
    return config
  },
  error => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  response => {
    return response.data
  },
  error => {
    console.error('响应错误:', error)
    return Promise.reject(error)
  }
)

// ==================== API接口定义 ====================

/**
 * 获取统计数据
 */
export const getStats = () => {
  return request.get('/api/stats')
}

/**
 * 获取剧本列表
 * @param {Object} params - 查询参数
 * @param {string} params.quickFilter - 快捷筛选 (pending/s_potential/project)
 * @param {string} params.status - 状态筛选
 * @param {string} params.source - 来源筛选
 * @param {string} params.search - 搜索关键词
 */
export const getScripts = (params = {}) => {
  return request.get('/api/scripts', { params })
}

/**
 * 获取剧本详情
 * @param {string} scriptId - 剧本ID
 */
export const getScriptDetail = (scriptId) => {
  return request.get(`/api/scripts/${scriptId}`)
}

/**
 * 新增剧本
 * @param {Object} data - 剧本数据
 */
export const createScript = (data) => {
  return request.post('/api/scripts', data)
}

/**
 * 更新剧本
 * @param {string} scriptId - 剧本ID
 * @param {Object} data - 剧本数据
 */
export const updateScript = (scriptId, data) => {
  return request.put(`/api/scripts/${scriptId}`, data)
}

/**
 * 删除剧本
 * @param {string} scriptId - 剧本ID
 */
export const deleteScript = (scriptId) => {
  return request.delete(`/api/scripts/${scriptId}`)
}

/**
 * 获取评分历史
 * @param {string} scriptId - 剧本ID
 */
export const getRatingHistory = (scriptId) => {
  return request.get(`/api/scripts/${scriptId}/ratings`)
}

/**
 * 提交评分
 * @param {string} scriptId - 剧本ID
 * @param {Object} data - 评分数据
 * @param {number} data.contentScore - 内容分数
 * @param {number} data.marketScore - 市场分数
 * @param {number} data.commercialScore - 商业分数
 * @param {number} data.complianceScore - 合规分数
 * @param {string} data.comments - 评语
 */
export const submitRating = (scriptId, data) => {
  return request.post(`/api/scripts/${scriptId}/ratings`, data)
}

/**
 * 获取剧本排行榜
 * @param {number} limit - 返回数量，默认100
 */
export const getRankings = (limit = 100) => {
  return request.get('/api/scripts/rankings', { params: { limit } })
}

export default request
