$(document).on('turbo:load', function() {
  $('form').on('submit', function(event) {
    const cnsNumberField = $('#cns_number');

    if (cnsNumberField.length !== 15) {
      cnsNumberField.addClass('required-empty').after('<span class="required-error">CNS deve conter 15 dígitos</span>');
      event.preventDefault();
    }
  });
});
