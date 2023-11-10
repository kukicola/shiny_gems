import { Tooltip, Toast } from 'bootstrap'
import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap-icons/font/bootstrap-icons.scss'
import '../css/app.scss'

(function () {
  const toastElList = document.querySelectorAll('.toast')
  toastElList.forEach(function (toastEl) {
    new Toast(toastEl, {}).show()
  })

  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
  tooltipTriggerList.forEach(function (tooltip) {
    new Tooltip(tooltip)
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
