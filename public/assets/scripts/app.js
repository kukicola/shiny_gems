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
    form.querySelectorAll("select, input").forEach(function (select) {
      select.addEventListener('change', function() {
        select.closest('form').submit();
      })
    })
  })

  const uploadButtons = document.querySelectorAll('button[data-upload]')
  uploadButtons.forEach(function (button) {
    button.addEventListener('click', function(event) {
      event.preventDefault();
      button.closest("form").querySelector("input[type=file]").click()
    })
  })
})()
