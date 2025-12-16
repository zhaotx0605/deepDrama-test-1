#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "========================================"
echo "  DeepDrama 网络配置检查工具"
echo "========================================"
echo

# 获取本机IP
echo -e "${BLUE}[1/5] 检查本机IP地址...${NC}"
if command -v ip &> /dev/null; then
    LOCAL_IP=$(ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p')
elif command -v ifconfig &> /dev/null; then
    LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
else
    echo -e "${YELLOW}⚠ 无法自动检测IP地址${NC}"
    read -p "请手动输入本机IP: " LOCAL_IP
fi

if [ -z "$LOCAL_IP" ]; then
    echo -e "${RED}✗ 无法获取本机IP${NC}"
    exit 1
fi

echo -e "${GREEN}✓ 本机IP: $LOCAL_IP${NC}"
echo

# 检查端口监听
echo -e "${BLUE}[2/5] 检查端口监听状态...${NC}"

check_port() {
    local port=$1
    local name=$2
    
    if command -v lsof &> /dev/null; then
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            local listen_addr=$(lsof -Pi :$port -sTCP:LISTEN | grep LISTEN | awk '{print $9}' | head -1)
            if [[ $listen_addr == *"0.0.0.0"* ]] || [[ $listen_addr == *"*"* ]]; then
                echo -e "${GREEN}✓ $name (端口 $port) - 监听所有接口${NC}"
                return 0
            else
                echo -e "${YELLOW}⚠ $name (端口 $port) - 仅监听 $listen_addr${NC}"
                echo -e "  ${YELLOW}建议：修改配置以监听 0.0.0.0${NC}"
                return 1
            fi
        else
            echo -e "${RED}✗ $name (端口 $port) - 未运行${NC}"
            return 2
        fi
    elif command -v netstat &> /dev/null; then
        if netstat -tuln | grep ":$port " >/dev/null 2>&1; then
            local listen_addr=$(netstat -tuln | grep ":$port " | awk '{print $4}' | head -1)
            if [[ $listen_addr == *"0.0.0.0"* ]] || [[ $listen_addr == *":::"* ]]; then
                echo -e "${GREEN}✓ $name (端口 $port) - 监听所有接口${NC}"
                return 0
            else
                echo -e "${YELLOW}⚠ $name (端口 $port) - 仅监听 $listen_addr${NC}"
                return 1
            fi
        else
            echo -e "${RED}✗ $name (端口 $port) - 未运行${NC}"
            return 2
        fi
    else
        echo -e "${YELLOW}⚠ 无法检查端口（lsof 和 netstat 都不可用）${NC}"
        return 3
    fi
}

backend_status=0
frontend_status=0

check_port 8080 "后端服务"
backend_status=$?

check_port 5173 "前端服务"
frontend_status=$?

echo

# 检查防火墙
echo -e "${BLUE}[3/5] 检查防火墙状态...${NC}"

if command -v firewall-cmd &> /dev/null; then
    if systemctl is-active --quiet firewalld; then
        echo "防火墙: firewalld (运行中)"
        if firewall-cmd --list-ports | grep -q "8080/tcp"; then
            echo -e "${GREEN}✓ 端口 8080 已开放${NC}"
        else
            echo -e "${YELLOW}⚠ 端口 8080 未开放${NC}"
            echo "  执行: sudo firewall-cmd --permanent --add-port=8080/tcp"
        fi
        if firewall-cmd --list-ports | grep -q "5173/tcp"; then
            echo -e "${GREEN}✓ 端口 5173 已开放${NC}"
        else
            echo -e "${YELLOW}⚠ 端口 5173 未开放${NC}"
            echo "  执行: sudo firewall-cmd --permanent --add-port=5173/tcp"
        fi
    else
        echo "防火墙: firewalld (未运行)"
    fi
elif command -v ufw &> /dev/null; then
    if ufw status | grep -q "Status: active"; then
        echo "防火墙: ufw (运行中)"
        if ufw status | grep -q "8080"; then
            echo -e "${GREEN}✓ 端口 8080 已开放${NC}"
        else
            echo -e "${YELLOW}⚠ 端口 8080 未开放${NC}"
            echo "  执行: sudo ufw allow 8080/tcp"
        fi
        if ufw status | grep -q "5173"; then
            echo -e "${GREEN}✓ 端口 5173 已开放${NC}"
        else
            echo -e "${YELLOW}⚠ 端口 5173 未开放${NC}"
            echo "  执行: sudo ufw allow 5173/tcp"
        fi
    else
        echo "防火墙: ufw (未运行)"
    fi
else
    echo -e "${YELLOW}⚠ 未检测到常见防火墙（firewalld/ufw）${NC}"
    echo "  Windows: 检查 Windows Defender 防火墙"
    echo "  Mac: 通常不需要配置"
fi

echo

# 测试本地连接
echo -e "${BLUE}[4/5] 测试本地连接...${NC}"

test_url() {
    local url=$1
    local name=$2
    
    if command -v curl &> /dev/null; then
        if curl -s --connect-timeout 3 "$url" > /dev/null 2>&1; then
            echo -e "${GREEN}✓ $name 连接成功${NC}"
            return 0
        else
            echo -e "${RED}✗ $name 连接失败${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠ curl 不可用，跳过连接测试${NC}"
        return 2
    fi
}

if [ $backend_status -eq 0 ]; then
    test_url "http://localhost:8080/api/stats" "后端 API (localhost)"
    test_url "http://$LOCAL_IP:8080/api/stats" "后端 API ($LOCAL_IP)"
else
    echo -e "${YELLOW}⚠ 后端未运行，跳过测试${NC}"
fi

if [ $frontend_status -eq 0 ]; then
    test_url "http://localhost:5173" "前端 (localhost)"
    test_url "http://$LOCAL_IP:5173" "前端 ($LOCAL_IP)"
else
    echo -e "${YELLOW}⚠ 前端未运行，跳过测试${NC}"
fi

echo

# 显示访问地址
echo -e "${BLUE}[5/5] 访问地址汇总${NC}"
echo "========================================"
echo -e "${GREEN}本机访问：${NC}"
echo "  前端: http://localhost:5173"
echo "  后端: http://localhost:8080"
echo
echo -e "${GREEN}局域网访问（其他机器）：${NC}"
echo "  前端: http://$LOCAL_IP:5173"
echo "  后端: http://$LOCAL_IP:8080"
echo "========================================"
echo

# 配置建议
echo -e "${BLUE}配置检查结果：${NC}"

all_good=true

if [ $backend_status -ne 0 ]; then
    all_good=false
    echo -e "${RED}✗ 后端服务未运行${NC}"
    echo "  启动: cd backend && mvn spring-boot:run"
fi

if [ $frontend_status -ne 0 ]; then
    all_good=false
    echo -e "${RED}✗ 前端服务未运行${NC}"
    echo "  启动: cd frontend && npm run dev"
fi

if [ $backend_status -eq 1 ]; then
    all_good=false
    echo -e "${YELLOW}⚠ 后端未监听所有接口${NC}"
    echo "  修改: backend/src/main/resources/application.yml"
    echo "  添加: server.address: 0.0.0.0"
fi

if [ $frontend_status -eq 1 ]; then
    all_good=false
    echo -e "${YELLOW}⚠ 前端未监听所有接口${NC}"
    echo "  修改: frontend/package.json"
    echo "  改为: \"dev\": \"vite --host 0.0.0.0\""
fi

if [ "$all_good" = true ]; then
    echo -e "${GREEN}✓ 所有配置正确，系统已就绪！${NC}"
fi

echo
echo "========================================"
echo "详细配置指南: 局域网部署指南.md"
echo "========================================"
