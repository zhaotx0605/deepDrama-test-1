// PM2 配置文件 - 用于管理DeepDrama前端服务
// 文档: https://pm2.keymetrics.io/docs/usage/application-declaration/

module.exports = {
  apps: [
    {
      // 应用名称
      name: 'deepdrama-frontend',
      
      // 使用npx来运行vite（因为vite在devDependencies中）
      script: 'npx',
      args: 'vite --host 0.0.0.0 --port 5173',
      
      // 工作目录
      cwd: '/home/user/webapp/frontend',
      
      // 环境变量
      env: {
        NODE_ENV: 'development',
        PORT: 5173
      },
      
      // 单实例运行
      instances: 1,
      exec_mode: 'fork',
      
      // 禁用自动重启（开发模式下）
      autorestart: true,
      watch: false,
      
      // 日志配置
      error_file: './logs/error.log',
      out_file: './logs/out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      
      // 最大内存限制（可选）
      max_memory_restart: '500M'
    }
  ]
}
