$(document).on('turbo:load', function() {
  $('form').on('submit', function(event) {
    const $requiredFields = $('.required');

    if ($requiredFields.filter(function() { return !$(this).val(); }).length) {
      $requiredFields.removeClass('required-empty');
      $('.required-error').remove();
      $requiredFields.addClass('required-empty').after('<span class="required-error">Campo obrigatório</span>');

      event.preventDefault();
    }
  });

  $('.required').on('input', function() {
    const $this = $(this);

    if ($this.val()) {
      $this.removeClass('required-empty').next('.required-error').remove();
    }
  });
});
