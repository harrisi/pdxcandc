;(function () {
  const eventSource = new EventSource('/live-reload')

  eventSource.onmessage = event => {
    let maybe_match
    if (event.data === 'reload') {
      console.log('reloading...')
      window.location.reload()
    } else if (
      (maybe_match = /c (?<num_clients>\d+)/.exec(event.data)) !== null
    ) {
      const { num_clients } = maybe_match.groups
      const live_count_el = document.querySelector('div#live_count')
      const live_count_number_el = live_count_el.querySelector('#live_count_number')
      const live_count_label_el = live_count_el.querySelector('#live_count_label')
      if (num_clients > 1) {
        live_count_number_el.innerHTML = num_clients
        live_count_label_el.innerHTML = 'people here!'
        live_count_el.style.display = 'block'
      } else {
        live_count_number_el.innerHTML = ''
        live_count_label_el.innerHTML = "You're the only one here!"
        live_count_el.style.display = 'none'
      }
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
