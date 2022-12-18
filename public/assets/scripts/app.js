(function () {
  const toastElList = document.querySelectorAll('.toast')
  toastElList.forEach(function (toastEl) {
    new bootstrap.Toast(toastEl, {}).show()
  })

  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
  tooltipTriggerList.forEach(function (tooltip) {
    new bootstrap.Tooltip(tooltip)
  })

  const autoSaveForms = document.querySelectorAll('[data-autosave]')
  autoSaveForms.forEach(function (form) {
    form.querySelectorAll("select").forEach(function (select) {
      select.addEventListener('change', function() {
        select.closest('form').submit();
      })
    })
  })

  const formConfirmElems = document.querySelectorAll('form[data-confirm]')
  formConfirmElems.forEach(function (form) {
    form.addEventListener('submit', function(event) {
      return confirm(form.dataset.confirm) || event.preventDefault();
    })
  })
})()
