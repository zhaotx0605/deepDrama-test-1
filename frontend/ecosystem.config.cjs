module.exports = {
  apps: [
    {
      name: 'deepdrama-frontend',
      script: 'serve-static.js',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      },
      watch: false,
      instances: 1,
      exec_mode: 'fork'
    }
  ]
}
