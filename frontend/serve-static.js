import { Hono } from 'hono'
import { serveStatic } from '@hono/node-server/serve-static'
import { serve } from '@hono/node-server'

const app = new Hono()

// Serve static files from dist directory
app.use('/*', serveStatic({ root: './dist' }))

// Fallback to index.html for SPA routing
app.get('*', serveStatic({ path: './dist/index.html' }))

const port = 3000
console.log(`🚀 DeepDrama Frontend Server running at http://0.0.0.0:${port}`)

serve({
  fetch: app.fetch,
  port: port,
  hostname: '0.0.0.0'
})
