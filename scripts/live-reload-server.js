const http = require('http')

const PORT = 4321 || process.env.PORT

const clients = new Set()

const log = message => {
  console.log(`[${new Date().toISOString()}] ${message}`)
}

const server = http.createServer((req, res) => {
  log(`${req.method} ${req.url} from ${req.socket.remoteAddress}`)

  if (req.socket.remoteAddress !== '127.0.0.1' && req.socket.remoteAddress !== '::1') {
    log('forbidden')
    res.writeHead(403, { 'Content-Type': 'text/plain' })
    res.end('forbidden')
    return
  }

  if (req.method === 'POST') {
    notifyClients()
    log('notified clients')
    res.writeHead(200, { 'Content-Type': 'text/plain' })
    res.end('ok')
    return
  }

  log('new client connected')

  res.writeHead(200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive',
  })

  clients.add(res)

  req.on('close', () => {
    log('client disconnected')
    clients.delete(res)
  })
})

const notifyClients = () => {
  log(`Notifying ${clients.size} clients...`)
  clients.forEach(client => {
    client.write(`data: reload\n\n`)
  })
}

server.listen(PORT, 'localhost', () => log(`Live reload server running on http://localhost:${PORT}`))

process.on('SIGINT', () => {
  log('Shutting down live reload server...')
  clients.forEach(client => client.end())
  process.exit()
})