# 🚀 前端启动指南

## 📋 前置条件确认

✅ **后端已启动**: 您的Java后端应该运行在 `http://localhost:8080`

## 🎯 简单3步启动前端

### 步骤1: 打开终端，进入前端目录

```bash
cd deepDrama-test-1/frontend
```

### 步骤2: 安装依赖（首次运行需要）

```bash
npm install
```

**注意**: 如果已经安装过了，可以跳过这步。

### 步骤3: 启动开发服务器

```bash
npm run dev
```

看到类似这样的输出就成功了：

```
  VITE v7.2.4  ready in 500 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: http://192.168.1.100:5173/
  ➜  press h + enter to show help
```

### 步骤4: 打开浏览器访问

打开浏览器访问: **http://localhost:5173/**

---

## ✨ 您会看到什么？

1. **数据看板** - 显示剧本统计数据（来自您的Java后端）
2. **剧本管理** - 剧本列表、筛选、搜索功能
3. **剧本排行** - Top 100排行榜

---

## ❓ PM2是什么？

**简单回答**: PM2是一个进程管理工具，用于在服务器上保持应用运行。

**您本地开发时**:
- ✅ **不需要PM2**
- ✅ 只需要 `npm run dev` 命令
- ✅ PM2主要用于生产环境

**PM2的作用**:
- 让应用在后台运行（即使关闭终端）
- 自动重启崩溃的应用
- 负载均衡和集群模式
- 日志管理

**对比**:
```bash
# 本地开发（推荐）
npm run dev         # 前台运行，Ctrl+C停止

# 生产环境（服务器）
pm2 start app.js    # 后台运行，不会停止
```

---

## 🔧 常用命令

### 开发模式（本地）

```bash
# 启动开发服务器（热更新）
npm run dev

# 停止服务器
按 Ctrl + C
```

### 生产构建

```bash
# 构建生产版本
npm run build

# 预览生产构建
npm run preview
```

---

## 🌐 前端连接后端配置

前端已配置为连接到 `http://localhost:8080`

如果您的后端运行在其他地址，修改这个文件：

**文件**: `frontend/src/api/index.js`

```javascript
// 修改这行
const BASE_URL = 'http://localhost:8080'  // 改成您的后端地址
```

---

## 📊 功能说明

### 1. 数据看板
- KPI指标卡片（总数、转化率、待评、平均分）
- 评级漏斗图
- 来源分析图
- 状态分布图

### 2. 剧本管理
- 快捷筛选（全部/待评分/S级潜力/已立项）
- 搜索功能（按名称或编号）
- 高级筛选（状态、来源）
- 数据表格（分页显示）
- 操作按钮（查看/评分/编辑/删除）

### 3. 剧本排行
- Top 100排名
- 奖牌图标（🥇🥈🥉）
- S级"爆款预测"标签
- 评级彩色标签

---

## ❌ 常见问题

### Q1: npm run dev 报错？

**检查Node.js版本**:
```bash
node -v    # 应该 >= 16.0.0
npm -v     # 应该 >= 8.0.0
```

**如果版本太低，需要更新Node.js**

### Q2: 依赖安装失败？

```bash
# 清理缓存重试
rm -rf node_modules package-lock.json
npm install
```

或使用国内镜像：
```bash
npm install --registry=https://registry.npmmirror.com
```

### Q3: 页面打开是空白？

**检查后端是否运行**:
```bash
curl http://localhost:8080/api/stats
```

如果返回数据，说明后端正常。

**检查浏览器控制台**:
- 按F12打开开发者工具
- 查看Console标签页是否有错误

### Q4: 端口5173被占用？

修改端口：

**文件**: `frontend/vite.config.js`

```javascript
export default defineConfig({
  plugins: [vue()],
  server: {
    port: 3000  // 改成其他端口
  }
})
```

### Q5: 连接后端失败（CORS错误）？

确保Java后端已配置CORS（您的代码已经配置了）。

如果仍有问题，检查：
1. 后端是否运行在8080端口
2. `WebConfig.java`的CORS配置是否正确

---

## 🎨 项目技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue 3 | 3.5+ | 前端框架 |
| Arco Design | 2.57+ | UI组件库 |
| ECharts | 6.0+ | 图表库 |
| Axios | 1.13+ | HTTP客户端 |
| Vite | 7.2+ | 构建工具 |

---

## 📸 界面预览

### 数据看板
- 4个KPI指标卡片（蓝、绿、橙、紫渐变背景）
- 3个图表（评级漏斗、来源分析、状态分布）

### 剧本管理
- 顶部快捷筛选按钮
- 搜索框和高级筛选
- 数据表格（支持分页）
- 彩色评级标签（S紫/A青/B绿/C橙/D红）

### 剧本排行
- 排名列表
- 前三名奖牌
- S级红色"爆款预测"标签

---

## 🔄 开发流程

### 日常开发

```bash
# 1. 确保后端运行
cd backend
mvn spring-boot:run

# 2. 新终端，启动前端
cd frontend
npm run dev

# 3. 浏览器访问
http://localhost:5173/

# 4. 修改代码，自动热更新
# 修改 src/ 下的文件会自动刷新浏览器
```

### 停止服务

```bash
# 前端
在终端按 Ctrl + C

# 后端
在终端按 Ctrl + C
```

---

## 🚀 生产部署（可选）

### 构建前端

```bash
cd frontend
npm run build
```

生成的文件在 `frontend/dist/` 目录

### 部署选项

**1. 静态服务器（Nginx/Apache）**
- 将`dist/`目录内容复制到服务器
- 配置反向代理到后端API

**2. Node.js服务器**
```bash
npm install -g serve
serve -s dist -p 80
```

**3. Cloudflare Pages / Vercel / Netlify**
- 直接上传`dist/`目录
- 配置环境变量指向后端API

---

## 📝 总结

✅ **不需要PM2** - 本地开发用 `npm run dev` 即可  
✅ **前端端口**: 5173  
✅ **后端端口**: 8080  
✅ **热更新**: 修改代码自动刷新  
✅ **停止服务**: Ctrl + C  

---

## 🎯 快速启动命令

```bash
# 打开两个终端

# 终端1: 启动后端
cd deepDrama-test-1/backend
mvn spring-boot:run

# 终端2: 启动前端
cd deepDrama-test-1/frontend
npm run dev

# 浏览器访问
http://localhost:5173/
```

---

**祝您使用愉快！** 🎉

如有问题，请查看上方的"常见问题"部分。
