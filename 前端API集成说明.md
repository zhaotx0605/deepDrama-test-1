# 🔥 前端API集成说明 - 已修复

## ⚠️ 问题确认

你说得对！原来的前端代码**完全没有调用API**，全部使用的是硬编码的Mock假数据。

## ✅ 已修复内容

### 修复前（旧代码）
```javascript
// ❌ 使用假数据
const mockScripts = [
  { id: 1, scriptId: 'SP001', name: '总裁的替嫁甜妻', ... },
  // ...更多假数据
]
const scripts = ref(mockScripts)
```

**问题**：
- ❌ 没有导入API模块
- ❌ 没有调用后端接口
- ❌ 所有数据都是硬编码
- ❌ 按钮点击无任何网络请求

### 修复后（新代码）
```javascript
// ✅ 导入真实API
import { getStats, getScripts, getRankings, deleteScript } from './api/index.js'

// ✅ 调用真实API
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
```

---

## 📊 新增API调用功能

### 1. **数据看板**
```javascript
// 调用 GET /api/stats
const loadStats = async () => {
  const data = await getStats()
  stats.value = {
    totalScripts: data.totalScripts || 0,
    projectCount: data.totalProjects || 0,
    pendingRating: data.pendingRatings || 0,
    conversionRate: data.conversionRate || 0,
    avgScore: data.averageScore || 0
  }
}
```

**对应后端接口**: `http://localhost:8080/api/stats`

---

### 2. **剧本管理**
```javascript
// 调用 GET /api/scripts
const loadScripts = async () => {
  const data = await getScripts()
  scripts.value = data || []
}
```

**对应后端接口**: `http://localhost:8080/api/scripts`

---

### 3. **剧本排行榜**
```javascript
// 调用 GET /api/scripts/rankings?limit=10
const loadLeaderboard = async () => {
  const data = await getRankings(10)
  leaderboardData.value = data || []
}
```

**对应后端接口**: `http://localhost:8080/api/scripts/rankings`

---

### 4. **删除剧本**
```javascript
// 调用 DELETE /api/scripts/:scriptId
const handleDelete = async (scriptId) => {
  await deleteScript(scriptId)
  await loadScripts()  // 删除后重新加载列表
}
```

**对应后端接口**: `http://localhost:8080/api/scripts/{scriptId}`

---

## 🔍 如何验证API调用

### 方法1：查看浏览器控制台（推荐）
1. 打开浏览器访问 `http://localhost:5173`
2. 按 `F12` 打开开发者工具
3. 切换到 **Console（控制台）** 标签
4. 你应该看到：
   ```
   App 组件已挂载，开始加载数据...
   正在加载统计数据...
   统计数据: {totalScripts: 30, conversionRate: 30, ...}
   正在加载剧本列表...
   剧本列表: [{scriptId: "SP001", name: "..."}, ...]
   ```

### 方法2：查看网络请求
1. 在开发者工具中切换到 **Network（网络）** 标签
2. 刷新页面
3. 你应该看到以下请求：
   - `GET http://localhost:8080/api/stats` - 状态码 200
   - `GET http://localhost:8080/api/scripts` - 状态码 200

### 方法3：点击按钮测试
1. 点击"**刷新数据**"按钮
2. 在Network标签中应该看到对应的API请求
3. 点击"**删除**"按钮
4. 应该看到 `DELETE /api/scripts/SP001` 请求

---

## 🎯 测试步骤

### 完整测试流程

#### 1. 启动后端（在本地）
```bash
cd /你下载代码的路径/webapp/backend
mvn spring-boot:run
```

验证后端：
```bash
curl http://localhost:8080/api/stats
# 应该返回JSON数据
```

#### 2. 前端已启动（沙盒中）
前端已通过PM2启动，访问地址：
- **本地**: http://localhost:5173
- **公网**: https://5173-i2wvcn4zqt161qrx2sfpj-5c13a017.sandbox.novita.ai

#### 3. 打开浏览器测试
1. 访问 http://localhost:5173
2. 按 `F12` 打开控制台
3. 查看Console输出，应该看到API调用日志
4. 切换到Network标签，查看请求记录

#### 4. 功能测试
| 功能 | 操作 | 预期结果 |
|------|------|---------|
| **数据看板** | 点击侧边栏"数据看板" | 显示统计数据，Console输出"正在加载统计数据..." |
| **剧本管理** | 点击侧边栏"剧本管理" | 显示剧本列表，Network显示GET /api/scripts |
| **搜索功能** | 输入"总裁"搜索 | 列表过滤显示匹配结果 |
| **快捷筛选** | 点击"待评分"按钮 | 显示未评分的剧本 |
| **刷新数据** | 点击"刷新数据"按钮 | Network显示对应API请求 |
| **删除剧本** | 点击某个剧本的"删除"按钮 | Network显示DELETE请求，列表刷新 |
| **排行榜** | 点击侧边栏"剧本排行" | 显示Top 10，Network显示GET /api/scripts/rankings |

---

## 📝 代码对比

### API配置文件（src/api/index.js）
```javascript
import axios from 'axios'

// ✅ 后端地址配置
const BASE_URL = 'http://localhost:8080'

const request = axios.create({
  baseURL: BASE_URL,
  timeout: 10000
})

// ✅ API接口定义
export const getStats = () => request.get('/api/stats')
export const getScripts = (params = {}) => request.get('/api/scripts', { params })
export const getRankings = (limit = 100) => request.get('/api/scripts/rankings', { params: { limit } })
export const deleteScript = (scriptId) => request.delete(`/api/scripts/${scriptId}`)
```

### 新增Console日志
每个API调用都会输出详细日志：
```javascript
console.log('正在加载统计数据...')
console.log('统计数据:', data)
console.log('正在加载剧本列表...')
console.log('剧本列表:', data)
console.log('删除剧本:', scriptId)
```

**作用**：方便你在浏览器控制台实时看到API调用过程。

---

## ⚠️ 如果仍然没有网络请求

### 检查清单

#### 1. 后端是否启动？
```bash
curl http://localhost:8080/api/stats
```
如果返回错误，说明后端没启动或端口不对。

#### 2. 前端是否使用新代码？
```bash
cd /home/user/webapp/frontend/src
grep -n "import.*api" App.vue
# 应该显示: import { getStats, getScripts, ... } from './api/index.js'
```

#### 3. 浏览器是否缓存旧代码？
- 按 `Ctrl + Shift + R`（Windows/Linux）
- 或 `Cmd + Shift + R`（Mac）
- 强制刷新浏览器

#### 4. 检查PM2日志
```bash
pm2 logs deepdrama-frontend --nostream --lines 30
```

---

## 🎉 确认修复成功的标志

如果你在浏览器中看到：
1. ✅ **Console有日志**：`正在加载统计数据...`、`统计数据: {...}`
2. ✅ **Network有请求**：`GET http://localhost:8080/api/stats`
3. ✅ **按钮可点击**：点击刷新/删除按钮有反应
4. ✅ **数据动态加载**：不是固定的假数据

那就说明API集成成功了！🎊

---

## 📦 文件清单

### 修改的文件
1. **src/App.vue** - 完全重写，使用真实API
2. **src/api/index.js** - API配置文件（已存在）

### 备份文件
1. **src/App.vue.old** - 旧版（假数据版本）
2. **src/App.vue.backup** - 原始备份

---

## 💡 下一步

1. 在本地启动Java后端
2. 访问前端 http://localhost:5173
3. 按F12查看Console和Network
4. 点击各种按钮测试功能

如果还有问题，请查看：
- **Console错误信息**
- **Network请求状态码**
- **PM2日志**：`pm2 logs deepdrama-frontend`

祝你测试顺利！🚀
