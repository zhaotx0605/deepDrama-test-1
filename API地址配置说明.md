# 🔧 API地址配置说明

## ❌ 你遇到的问题

访问 `http://你的IP:5173` 时：
- Console显示：`API Base URL: http://localhost:8080`
- Network请求：`http://localhost:8080/api/...`

**问题原因**：`.env.development` 文件配置了固定的 `VITE_API_BASE_URL=http://localhost:8080`

---

## ✅ 已修复

### 修改内容
1. **`.env.development`** 文件已改为空值，启用自动检测
2. **`src/api/index.js`** 优化了自动检测逻辑，增加日志输出

---

## 🚀 使用方式

### 方法1：自动检测（推荐）⭐

**无需任何配置！** 系统会自动检测：

#### 访问 localhost → 使用 localhost 后端
```
浏览器访问: http://localhost:5173
Console输出: ✓ API Base URL: http://localhost:8080
实际请求: http://localhost:8080/api/stats
```

#### 访问 IP地址 → 使用 IP 后端
```
浏览器访问: http://192.168.1.100:5173
Console输出: ✓ API Base URL: http://192.168.1.100:8080
实际请求: http://192.168.1.100:8080/api/stats
```

---

### 方法2：手动指定后端地址

如果自动检测不符合你的需求，可以手动配置：

#### 创建 `.env.local` 文件
```bash
cd /你的路径/webapp/frontend
echo "VITE_API_BASE_URL=http://192.168.1.100:8080" > .env.local
```

#### 重启前端
```bash
npm run dev
```

**优先级**：`.env.local` > `.env.development`

---

## 🔄 重启前端生效

**重要**：修改环境变量后，必须重启前端服务！

### 方法1：Ctrl+C 停止，然后重新启动
```bash
# 在前端终端按 Ctrl+C 停止
# 然后重新启动
npm run dev
```

### 方法2：使用PM2重启（如果用PM2）
```bash
cd /你的路径/webapp/frontend
pm2 restart deepdrama-frontend
```

---

## 🧪 验证是否生效

### 第1步：重启前端
```bash
cd /你的路径/webapp/frontend
npm run dev
```

### 第2步：在其他机器访问
```
http://192.168.1.100:5173
```
**（替换为你的实际IP）**

### 第3步：按F12查看Console
应该看到：
```
通过IP访问，自动使用IP后端: http://192.168.1.100:8080
✓ API Base URL: http://192.168.1.100:8080
```

### 第4步：查看Network标签
请求地址应该是：
```
GET http://192.168.1.100:8080/api/stats - 200 OK
```

---

## 📋 完整测试流程

### 在部署机器上

#### 1. 获取本机IP
```bash
# Windows
ipconfig

# Linux/Mac
ifconfig
```
假设得到：**192.168.1.100**

#### 2. 确认后端启动
```bash
curl http://192.168.1.100:8080/api/stats
```
应该返回JSON数据

#### 3. 停止前端（如果在运行）
按 `Ctrl+C` 停止当前的 `npm run dev`

#### 4. 重新启动前端
```bash
cd /你的路径/webapp/frontend
npm run dev
```

---

### 在其他机器上

#### 1. 打开浏览器
访问：`http://192.168.1.100:5173`

#### 2. 按F12打开开发者工具

#### 3. 查看Console标签
应该看到：
```
通过IP访问，自动使用IP后端: http://192.168.1.100:8080
✓ API Base URL: http://192.168.1.100:8080
App 组件已挂载，开始加载数据...
正在加载统计数据...
统计数据: {totalScripts: 30, ...}
```

#### 4. 查看Network标签
应该看到：
```
GET http://192.168.1.100:8080/api/stats - 200 OK
GET http://192.168.1.100:8080/api/scripts - 200 OK
```

#### 5. 验证页面
- ✅ 数据看板显示正确数据
- ✅ 剧本列表正常加载
- ✅ 所有按钮功能正常

---

## 🔍 故障排查

### 问题1：仍然显示 localhost

#### 症状
```
Console: API Base URL: http://localhost:8080
```

#### 原因
1. 前端没有重启
2. 创建了 `.env.local` 且配置了 localhost

#### 解决方案
```bash
# 1. 停止前端（Ctrl+C）

# 2. 检查并删除 .env.local（如果存在）
cd /你的路径/webapp/frontend
rm .env.local  # 如果有的话

# 3. 确认 .env.development 是空值
cat .env.development
# 应该显示: VITE_API_BASE_URL=

# 4. 重新启动
npm run dev
```

---

### 问题2：环境变量不生效

#### 症状
修改了 `.env.development` 但没有变化

#### 原因
Vite需要重启才能加载新的环境变量

#### 解决方案
```bash
# 完全停止前端
Ctrl+C

# 重新启动
npm run dev
```

---

### 问题3：Console显示 "使用环境变量配置"

#### 症状
```
使用环境变量配置的后端地址: http://localhost:8080
```

#### 原因
环境变量文件配置了固定地址

#### 解决方案A：删除环境变量配置
```bash
cd /你的路径/webapp/frontend
echo "VITE_API_BASE_URL=" > .env.development
npm run dev
```

#### 解决方案B：手动指定IP
```bash
cd /你的路径/webapp/frontend
echo "VITE_API_BASE_URL=http://192.168.1.100:8080" > .env.local
npm run dev
```

---

## 📁 环境变量文件说明

### 文件优先级
```
.env.local          (最高优先级，本地配置，不提交Git)
    ↓
.env.development    (开发环境，提交Git)
    ↓
.env.production     (生产环境，提交Git)
    ↓
自动检测逻辑        (最低优先级)
```

### 各文件的作用

#### .env.local（推荐用于个人配置）
```bash
# 个人本地配置，不会提交到Git
# 每个开发者可以有自己的配置
VITE_API_BASE_URL=http://192.168.1.100:8080
```

#### .env.development（团队开发配置）
```bash
# 团队统一的开发环境配置
# 留空表示启用自动检测（推荐）
VITE_API_BASE_URL=
```

#### .env.production（生产环境配置）
```bash
# 生产环境配置
# 留空表示自动检测
VITE_API_BASE_URL=
```

---

## 🎯 最佳实践

### 开发场景1：只在本机开发
```bash
# 不需要任何配置
# .env.development 留空
# 访问 localhost:5173，自动使用 localhost:8080
```

### 开发场景2：局域网协作
```bash
# 方式A：启用自动检测（推荐）
# .env.development 留空
# 访问 IP:5173，自动使用 IP:8080

# 方式B：手动指定后端
# 创建 .env.local
VITE_API_BASE_URL=http://192.168.1.100:8080
```

### 开发场景3：前后端分离部署
```bash
# 后端在 192.168.1.100
# 前端在 192.168.1.200
# 创建 .env.local
VITE_API_BASE_URL=http://192.168.1.100:8080
```

---

## 🔐 生产环境建议

### 使用Nginx反向代理
```nginx
server {
    listen 80;
    server_name your-domain.com;

    # 前端
    location / {
        root /path/to/frontend/dist;
        try_files $uri $uri/ /index.html;
    }

    # 后端API代理
    location /api/ {
        proxy_pass http://localhost:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

这样前端可以使用相对路径：
```javascript
VITE_API_BASE_URL=/api
```

---

## 📊 配置检查清单

### ✅ 正确配置
```
文件: .env.development
内容: VITE_API_BASE_URL=

文件: src/api/index.js
逻辑: 自动检测hostname

结果: 
- localhost访问 → localhost后端
- IP访问 → IP后端
```

### ❌ 错误配置
```
文件: .env.development
内容: VITE_API_BASE_URL=http://localhost:8080

结果:
- 所有访问方式都使用 localhost:8080
- 局域网其他机器无法连接
```

---

## 💡 快速修复命令

如果你现在遇到问题，执行这些命令：

```bash
# 1. 进入前端目录
cd /你的路径/webapp/frontend

# 2. 清空开发环境配置（启用自动检测）
echo "# 开发环境配置" > .env.development
echo "# 留空以启用自动检测" >> .env.development
echo "VITE_API_BASE_URL=" >> .env.development

# 3. 删除本地配置（如果有）
rm -f .env.local

# 4. 停止前端（按Ctrl+C）

# 5. 重新启动
npm run dev

# 6. 在其他机器访问 http://你的IP:5173
# 7. 按F12查看Console，确认显示IP地址
```

---

## 🎉 总结

### 配置原则
1. **默认启用自动检测**（`.env.development` 留空）
2. **需要固定地址时使用 `.env.local`**
3. **修改后必须重启前端**

### 验证成功
在其他机器访问时，Console应该显示：
```
✓ API Base URL: http://你的IP:8080
```

Network应该请求：
```
GET http://你的IP:8080/api/stats
```

现在重启前端，应该就能正常工作了！🚀
