# DeepDrama 部署指南

本文档提供完整的 DeepDrama 剧本管理系统部署指南。

## 📋 系统要求

### 后端环境
- JDK 8+
- Maven 3.6+
- MySQL 5.7+ 或 MySQL 8.0+
- 至少 2GB RAM
- 10GB 磁盘空间

### 前端环境
- Node.js 16+ 
- npm 8+ 或 yarn 1.22+

## 🚀 完整部署流程

### 步骤 1: 准备数据库

#### 1.1 安装 MySQL
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install mysql-server

# CentOS/RHEL
sudo yum install mysql-server

# macOS
brew install mysql
```

#### 1.2 启动 MySQL
```bash
# Ubuntu/Debian
sudo systemctl start mysql
sudo systemctl enable mysql

# macOS
mysql.server start
```

#### 1.3 创建数据库和用户
```bash
mysql -u root -p
```

```sql
-- 创建数据库
CREATE DATABASE deepdrama DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建用户（可选，建议生产环境使用）
CREATE USER 'deepdrama'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON deepdrama.* TO 'deepdrama'@'localhost';
FLUSH PRIVILEGES;
```

#### 1.4 初始化表结构
```bash
cd /path/to/webapp
mysql -u root -p deepdrama < database/schema.sql
```

#### 1.5 导入测试数据（可选）
```bash
mysql -u root -p deepdrama < database/seed.sql
```

### 步骤 2: 部署后端

#### 2.1 配置应用
编辑 `backend/src/main/resources/application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/deepdrama?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
    username: deepdrama  # 或 root
    password: your_secure_password
```

#### 2.2 构建项目
```bash
cd backend
mvn clean package -DskipTests
```

#### 2.3 运行后端

**开发环境：**
```bash
mvn spring-boot:run
```

**生产环境：**
```bash
# 方式1: 直接运行
java -jar target/deepdrama-backend-1.0.0.jar

# 方式2: 后台运行
nohup java -jar target/deepdrama-backend-1.0.0.jar > app.log 2>&1 &

# 方式3: 使用 systemd（推荐）
sudo vim /etc/systemd/system/deepdrama.service
```

**systemd 服务配置：**
```ini
[Unit]
Description=DeepDrama Backend Service
After=mysql.service

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/deepdrama/backend
ExecStart=/usr/bin/java -jar /opt/deepdrama/backend/target/deepdrama-backend-1.0.0.jar
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

启动服务：
```bash
sudo systemctl daemon-reload
sudo systemctl start deepdrama
sudo systemctl enable deepdrama
sudo systemctl status deepdrama
```

#### 2.4 验证后端
```bash
# 检查健康状态
curl http://localhost:8080/api/scripts

# 检查日志
tail -f app.log
# 或
sudo journalctl -u deepdrama -f
```

### 步骤 3: 部署前端

#### 3.1 安装依赖
```bash
cd frontend
npm install
```

#### 3.2 配置 API 地址

**开发环境** (`vite.config.js`):
```javascript
export default defineConfig({
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
})
```

**生产环境** (`.env.production`):
```
VITE_API_BASE_URL=http://your-domain.com:8080
```

#### 3.3 构建前端
```bash
npm run build
```

生成的文件在 `dist/` 目录。

#### 3.4 部署前端

**方式1: 使用 Nginx（推荐）**

安装 Nginx:
```bash
# Ubuntu/Debian
sudo apt-get install nginx

# CentOS/RHEL
sudo yum install nginx
```

配置 Nginx (`/etc/nginx/sites-available/deepdrama`):
```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    root /var/www/deepdrama/frontend/dist;
    index index.html;
    
    # SPA 路由支持
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # API 代理
    location /api/ {
        proxy_pass http://localhost:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

启用站点：
```bash
sudo ln -s /etc/nginx/sites-available/deepdrama /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

**方式2: 使用 Apache**

配置 Apache (`/etc/apache2/sites-available/deepdrama.conf`):
```apache
<VirtualHost *:80>
    ServerName your-domain.com
    DocumentRoot /var/www/deepdrama/frontend/dist
    
    <Directory /var/www/deepdrama/frontend/dist>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
        
        # SPA 路由支持
        RewriteEngine On
        RewriteBase /
        RewriteRule ^index\.html$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.html [L]
    </Directory>
    
    # API 代理
    ProxyPass /api http://localhost:8080/api
    ProxyPassReverse /api http://localhost:8080/api
</VirtualHost>
```

### 步骤 4: 配置 HTTPS（可选但推荐）

#### 使用 Let's Encrypt
```bash
# 安装 certbot
sudo apt-get install certbot python3-certbot-nginx

# 获取证书
sudo certbot --nginx -d your-domain.com

# 自动续期
sudo certbot renew --dry-run
```

## 🔧 环境配置

### 开发环境
```bash
# 后端
cd backend
mvn spring-boot:run

# 前端
cd frontend
npm run dev
```

访问：
- 前端: http://localhost:5173
- 后端: http://localhost:8080

### 生产环境

```bash
# 后端（使用 systemd）
sudo systemctl start deepdrama

# 前端（使用 Nginx）
sudo systemctl start nginx
```

访问：
- http://your-domain.com

## 📊 性能优化

### 后端优化

#### 1. JVM 参数调优
```bash
java -Xms512m -Xmx2g \
     -XX:+UseG1GC \
     -XX:MaxGCPauseMillis=200 \
     -jar deepdrama-backend-1.0.0.jar
```

#### 2. 数据库连接池
```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20
      minimum-idle: 10
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
```

#### 3. MySQL 优化
```sql
-- 创建索引
CREATE INDEX idx_script_status ON scripts(status);
CREATE INDEX idx_rating_script_date ON ratings(script_id, rating_date);

-- 查询缓存（MySQL 5.7）
SET GLOBAL query_cache_size = 67108864;
SET GLOBAL query_cache_type = ON;
```

### 前端优化

#### 1. 代码分割
```javascript
// router/index.js
const Dashboard = () => import('@/views/Dashboard.vue');
const ScriptManagement = () => import('@/views/ScriptManagement.vue');
```

#### 2. 资源压缩
```javascript
// vite.config.js
export default defineConfig({
  build: {
    minify: 'terser',
    terserOptions: {
      compress: {
        drop_console: true,
        drop_debugger: true
      }
    },
    rollupOptions: {
      output: {
        manualChunks: {
          'arco-design': ['@arco-design/web-vue'],
          'echarts': ['echarts']
        }
      }
    }
  }
})
```

#### 3. CDN 加速
```html
<!-- index.html -->
<link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
```

## 🔒 安全加固

### 1. 数据库安全
```bash
# 禁用远程 root 登录
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
FLUSH PRIVILEGES;

# 强密码策略
SET GLOBAL validate_password.policy=STRONG;
```

### 2. 应用安全
```yaml
# application.yml
spring:
  security:
    filter:
      order: 5
```

### 3. Nginx 安全
```nginx
# 隐藏版本信息
server_tokens off;

# 防止点击劫持
add_header X-Frame-Options "SAMEORIGIN";

# 防止 XSS
add_header X-XSS-Protection "1; mode=block";

# 防止 MIME 嗅探
add_header X-Content-Type-Options nosniff;
```

### 4. 防火墙配置
```bash
# 只开放必要端口
sudo ufw allow 22/tcp   # SSH
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw enable
```

## 📈 监控与日志

### 应用监控
```bash
# 使用 Spring Boot Actuator
# 添加依赖后访问
curl http://localhost:8080/actuator/health
curl http://localhost:8080/actuator/metrics
```

### 日志管理
```bash
# 使用 logrotate
sudo vim /etc/logrotate.d/deepdrama
```

```
/opt/deepdrama/logs/*.log {
    daily
    rotate 7
    compress
    delaycompress
    notifempty
    create 0644 www-data www-data
}
```

## 🔄 备份策略

### 数据库备份
```bash
# 每日自动备份
cat > /opt/scripts/backup-deepdrama.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/backup/deepdrama"
DATE=$(date +%Y%m%d)
mkdir -p $BACKUP_DIR
mysqldump -u deepdrama -p'password' deepdrama > $BACKUP_DIR/deepdrama_$DATE.sql
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
EOF

chmod +x /opt/scripts/backup-deepdrama.sh

# 添加到 crontab
crontab -e
# 每天凌晨 2 点备份
0 2 * * * /opt/scripts/backup-deepdrama.sh
```

## ❌ 常见问题

### Q: 后端启动失败
A: 检查：
1. MySQL 是否启动
2. 数据库连接配置是否正确
3. 端口 8080 是否被占用

### Q: 前端无法访问后端 API
A: 检查：
1. CORS 配置
2. Nginx 代理配置
3. 后端是否正常运行

### Q: 数据库连接超时
A: 检查：
1. MySQL 最大连接数
2. 连接池配置
3. 网络防火墙规则

## 📞 技术支持

如有问题，请联系技术团队：
- Email: tech@deepdrama.com
- GitHub: https://github.com/deepdrama/deepdrama
