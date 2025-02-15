const eventSource = new EventSource('/live-reload')

eventSource.addEventListener('message', event => {
  if (event.data === 'reload') {
    console.log('Reloading...')
    window.location.reload()
  } else {
    console.log('Unknown message:', event.data)
  }
})

eventSource.addEventListener('error', event => {
  console.error('Error:', event)
  setTimeout(() => {
    eventSource.close()
    window.location.reload()
  }, 1000)
})
