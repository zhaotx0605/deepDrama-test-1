# 🚀 本地启动脚本使用说明

## 问题说明

你遇到的问题是：**前端运行在沙盒（远程），后端运行在本地，无法通过localhost访问前端。**

---

## ✅ 解决方案：在本地启动前端

### 快速启动（3步）

#### 1. 下载代码到本地
你应该已经下载了代码到本地某个目录，比如：
- Windows: `C:\Users\你的用户名\Downloads\webapp`
- Linux/Mac: `/home/你的用户名/Downloads/webapp`

#### 2. 安装前端依赖（首次）
```bash
cd /你存放代码的路径/webapp/frontend
npm install
```

#### 3. 启动前端
```bash
npm run dev
```

启动成功后会显示：
```
VITE v7.3.0  ready in 500 ms

➜  Local:   http://localhost:5173/
➜  Network: http://192.168.x.x:5173/
```

现在访问 `http://localhost:5173` 就可以了！

---

## 📝 完整的本地启动流程

### 终端1：启动后端
```bash
cd /你存放代码的路径/webapp/backend
mvn spring-boot:run
```

### 终端2：启动前端
```bash
cd /你存放代码的路径/webapp/frontend
npm run dev
```

### 浏览器：访问
打开 `http://localhost:5173`

---

## 🎯 Windows一键启动脚本

创建 `start-local.bat` 文件（在webapp目录下）：

```batch
@echo off
chcp 65001 >nul
echo ========================================
echo   DeepDrama 本地启动脚本
echo ========================================
echo.

REM 修改这里为你的实际路径
set PROJECT_PATH=C:\Users\你的用户名\Downloads\webapp

echo [步骤 1/3] 检查项目路径...
if not exist "%PROJECT_PATH%" (
    echo 错误：项目路径不存在！
    echo 请修改脚本中的 PROJECT_PATH 变量
    pause
    exit /b 1
)
echo ✓ 项目路径正确

echo.
echo [步骤 2/3] 启动后端服务...
echo 后端将在新窗口中启动...
start "DeepDrama后端" cmd /k "cd /d %PROJECT_PATH%\backend && echo 正在启动后端... && mvn spring-boot:run"

echo 等待后端启动（10秒）...
timeout /t 10 /nobreak >nul

echo.
echo [步骤 3/3] 启动前端服务...
echo 前端将在新窗口中启动...
start "DeepDrama前端" cmd /k "cd /d %PROJECT_PATH%\frontend && echo 正在启动前端... && npm run dev"

echo.
echo ========================================
echo   启动完成！
echo ========================================
echo.
echo 请等待两个窗口中的服务启动完成
echo.
echo 访问地址：
echo   前端：http://localhost:5173
echo   后端：http://localhost:8080
echo.
echo 按任意键关闭此窗口...
pause >nul
```

**使用方法**：
1. 修改脚本中的 `PROJECT_PATH` 为你的实际路径
2. 双击 `start-local.bat` 运行
3. 会自动打开两个窗口分别运行后端和前端

---

## 🎯 Linux/Mac一键启动脚本

创建 `start-local.sh` 文件（在webapp目录下）：

```bash
#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================"
echo "  DeepDrama 本地启动脚本"
echo "========================================"
echo

# 修改这里为你的实际路径
PROJECT_PATH="/home/你的用户名/Downloads/webapp"

echo "[步骤 1/3] 检查项目路径..."
if [ ! -d "$PROJECT_PATH" ]; then
    echo -e "${RED}错误：项目路径不存在！${NC}"
    echo "请修改脚本中的 PROJECT_PATH 变量"
    exit 1
fi
echo -e "${GREEN}✓ 项目路径正确${NC}"

echo
echo "[步骤 2/3] 启动后端服务..."
cd "$PROJECT_PATH/backend"

# 使用tmux或screen运行后端（如果安装了）
if command -v tmux &> /dev/null; then
    tmux new-session -d -s deepdrama-backend "mvn spring-boot:run"
    echo -e "${GREEN}✓ 后端已在tmux会话中启动${NC}"
    echo "  查看后端日志: tmux attach -t deepdrama-backend"
elif command -v screen &> /dev/null; then
    screen -dmS deepdrama-backend bash -c "mvn spring-boot:run"
    echo -e "${GREEN}✓ 后端已在screen会话中启动${NC}"
    echo "  查看后端日志: screen -r deepdrama-backend"
else
    # 如果没有tmux或screen，使用nohup
    nohup mvn spring-boot:run > backend.log 2>&1 &
    echo -e "${GREEN}✓ 后端已启动（nohup模式）${NC}"
    echo "  查看后端日志: tail -f $PROJECT_PATH/backend/backend.log"
fi

echo "等待后端启动（10秒）..."
sleep 10

echo
echo "[步骤 3/3] 启动前端服务..."
cd "$PROJECT_PATH/frontend"

# 使用tmux或screen运行前端
if command -v tmux &> /dev/null; then
    tmux new-session -d -s deepdrama-frontend "npm run dev"
    echo -e "${GREEN}✓ 前端已在tmux会话中启动${NC}"
    echo "  查看前端日志: tmux attach -t deepdrama-frontend"
elif command -v screen &> /dev/null; then
    screen -dmS deepdrama-frontend bash -c "npm run dev"
    echo -e "${GREEN}✓ 前端已在screen会话中启动${NC}"
    echo "  查看前端日志: screen -r deepdrama-frontend"
else
    nohup npm run dev > frontend.log 2>&1 &
    echo -e "${GREEN}✓ 前端已启动（nohup模式）${NC}"
    echo "  查看前端日志: tail -f $PROJECT_PATH/frontend/frontend.log"
fi

echo
echo "========================================"
echo -e "${GREEN}  启动完成！${NC}"
echo "========================================"
echo
echo "访问地址："
echo "  前端：http://localhost:5173"
echo "  后端：http://localhost:8080"
echo
echo "停止服务："
if command -v tmux &> /dev/null; then
    echo "  tmux kill-session -t deepdrama-backend"
    echo "  tmux kill-session -t deepdrama-frontend"
elif command -v screen &> /dev/null; then
    echo "  screen -S deepdrama-backend -X quit"
    echo "  screen -S deepdrama-frontend -X quit"
else
    echo "  pkill -f 'mvn spring-boot:run'"
    echo "  pkill -f 'npm run dev'"
fi
echo
```

**使用方法**：
1. 修改脚本中的 `PROJECT_PATH` 为你的实际路径
2. 给脚本添加执行权限：`chmod +x start-local.sh`
3. 运行：`./start-local.sh`

---

## 🛑 停止服务

### 手动停止
在启动前端的终端按 `Ctrl+C`  
在启动后端的终端按 `Ctrl+C`

### 使用脚本停止（Linux/Mac）
创建 `stop-local.sh`：
```bash
#!/bin/bash
echo "停止DeepDrama服务..."

# 停止tmux会话
tmux kill-session -t deepdrama-backend 2>/dev/null
tmux kill-session -t deepdrama-frontend 2>/dev/null

# 或停止screen会话
screen -S deepdrama-backend -X quit 2>/dev/null
screen -S deepdrama-frontend -X quit 2>/dev/null

# 或杀掉进程
pkill -f "mvn spring-boot:run" 2>/dev/null
pkill -f "npm run dev" 2>/dev/null

echo "服务已停止"
```

---

## ⚠️ 重要提示

1. **不要在沙盒和本地同时启动前端**
   - 沙盒前端：访问不了本地后端
   - 本地前端：可以访问本地后端 ✓

2. **推荐配置**：
   - 后端：本地运行（`mvn spring-boot:run`）
   - 前端：本地运行（`npm run dev`）
   - 数据库：本地MySQL

3. **端口检查**：
   - 后端：8080端口不能被占用
   - 前端：5173端口不能被占用

---

## 📚 相关文档

- **详细解决方案**：`本地无法访问的解决方案.md`
- **前端启动指南**：`前端启动指南.md`
- **后端启动指南**：`JAVA_BACKEND_GUIDE.md`

---

## 🎉 总结

**当前状态**：
- ✅ 前端代码已修复（使用真实API）
- ✅ 代码已推送到GitHub
- ✅ 沙盒前端仍在运行（仅供演示）

**你需要做的**：
1. 在本地运行前端：`cd /你的路径/webapp/frontend && npm run dev`
2. 在本地运行后端：`cd /你的路径/webapp/backend && mvn spring-boot:run`
3. 访问：`http://localhost:5173`

这样前后端都在本地，完美联调！🚀
