(function () {
  document.querySelectorAll('.flash').forEach(function (elem) {
    setTimeout(function () {
      elem.classList.remove('show')
    }, 3000)
  })
})()
