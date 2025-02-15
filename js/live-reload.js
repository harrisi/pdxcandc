;(function () {
  const eventSource = new EventSource('/live-reload')

  eventSource.onmessage = event => {
    if (event.data === 'reload') {
      console.log('reloading...')
      window.location.reload()
    } else {
      console.log('unknown message:', event.data)
    }
  }

  eventSource.onerror = event => {
    console.error('error:', event)
    eventSource.close()
    setTimeout(() => {
      window.location.reload()
      // this seems to take about ten seconds to be able to re-establish the
      // connection. I'm sure there's a setting somewhere, but I've already
      // spent too much time on a useless feature.
    }, 11 * 1000)
  }

  eventSource.onopen = () => {
    console.log('connected to live-reload server')
  }
})()
