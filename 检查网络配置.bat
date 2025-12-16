@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo   DeepDrama 网络配置检查工具
echo ========================================
echo.

REM 获取本机IP
echo [1/5] 检查本机IP地址...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
    set IP=%%a
    set IP=!IP:~1!
    if not "!IP!"=="127.0.0.1" (
        set LOCAL_IP=!IP!
        goto :ip_found
    )
)
:ip_found

if "%LOCAL_IP%"=="" (
    echo [X] 无法获取本机IP
    pause
    exit /b 1
)

echo [√] 本机IP: %LOCAL_IP%
echo.

REM 检查端口监听
echo [2/5] 检查端口监听状态...

netstat -ano | findstr :8080 >nul 2>&1
if %errorlevel%==0 (
    echo [√] 后端服务 ^(端口 8080^) - 运行中
    set BACKEND_RUNNING=1
) else (
    echo [X] 后端服务 ^(端口 8080^) - 未运行
    echo     启动: cd backend ^&^& mvn spring-boot:run
    set BACKEND_RUNNING=0
)

netstat -ano | findstr :5173 >nul 2>&1
if %errorlevel%==0 (
    echo [√] 前端服务 ^(端口 5173^) - 运行中
    set FRONTEND_RUNNING=1
) else (
    echo [X] 前端服务 ^(端口 5173^) - 未运行
    echo     启动: cd frontend ^&^& npm run dev
    set FRONTEND_RUNNING=0
)

echo.

REM 检查防火墙
echo [3/5] 检查防火墙状态...
echo 防火墙: Windows Defender 防火墙
echo.
echo 请手动检查防火墙规则：
echo   1. 打开 控制面板 ^> Windows Defender 防火墙
echo   2. 点击 高级设置 ^> 入站规则
echo   3. 确认端口 8080 和 5173 已允许
echo.
echo 或使用管理员CMD执行：
echo   netsh advfirewall firewall add rule name="DeepDrama" dir=in action=allow protocol=TCP localport=8080,5173
echo.

REM 测试本地连接
echo [4/5] 测试本地连接...

if %BACKEND_RUNNING%==1 (
    curl -s http://localhost:8080/api/stats >nul 2>&1
    if %errorlevel%==0 (
        echo [√] 后端 API ^(localhost^) 连接成功
    ) else (
        echo [X] 后端 API ^(localhost^) 连接失败
    )
    
    curl -s http://%LOCAL_IP%:8080/api/stats >nul 2>&1
    if %errorlevel%==0 (
        echo [√] 后端 API ^(%LOCAL_IP%^) 连接成功
    ) else (
        echo [X] 后端 API ^(%LOCAL_IP%^) 连接失败
    )
) else (
    echo [!] 后端未运行，跳过测试
)

if %FRONTEND_RUNNING%==1 (
    curl -s http://localhost:5173 >nul 2>&1
    if %errorlevel%==0 (
        echo [√] 前端 ^(localhost^) 连接成功
    ) else (
        echo [X] 前端 ^(localhost^) 连接失败
    )
    
    curl -s http://%LOCAL_IP%:5173 >nul 2>&1
    if %errorlevel%==0 (
        echo [√] 前端 ^(%LOCAL_IP%^) 连接成功
    ) else (
        echo [X] 前端 ^(%LOCAL_IP%^) 连接失败
    )
) else (
    echo [!] 前端未运行，跳过测试
)

echo.

REM 显示访问地址
echo [5/5] 访问地址汇总
echo ========================================
echo 本机访问：
echo   前端: http://localhost:5173
echo   后端: http://localhost:8080
echo.
echo 局域网访问（其他机器）：
echo   前端: http://%LOCAL_IP%:5173
echo   后端: http://%LOCAL_IP%:8080
echo ========================================
echo.

REM 配置建议
echo 配置检查结果：
if %BACKEND_RUNNING%==0 (
    echo [X] 后端服务未运行
    echo     启动: cd backend ^&^& mvn spring-boot:run
)

if %FRONTEND_RUNNING%==0 (
    echo [X] 前端服务未运行
    echo     启动: cd frontend ^&^& npm run dev
)

if %BACKEND_RUNNING%==1 if %FRONTEND_RUNNING%==1 (
    echo [√] 所有服务正常运行！
)

echo.
echo ========================================
echo 详细配置指南: 局域网部署指南.md
echo ========================================
echo.
pause
