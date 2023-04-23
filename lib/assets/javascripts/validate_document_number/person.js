function validatePersonDocumentNumber(documentNumber) {
  documentNumber = documentNumber.replace(/[^\d]+/g,'');
  if (documentNumber.length !== 11 || /^(\d)\1{10}$/.test(documentNumber)) return false;

  let digit = 0;
  for (let i = 0; i < 9; i++) {
    digit += parseInt(documentNumber.charAt(i)) * (10 - i);
  }

  let rev = 11 - (digit % 11);
  if (rev > 9) rev = 0;

  if (rev !== parseInt(documentNumber.charAt(9))) return false;

  digit = 0;
  for (let i = 0; i < 10; i++) {
    digit += parseInt(documentNumber.charAt(i)) * (11 - i);
  }

  rev = 11 - (digit % 11);
  if (rev > 9) rev = 0;

  return rev === parseInt(documentNumber.charAt(10));
}

$(document).on('turbo:load', function() {
  $('form').on('submit', function(event) {
    const documentNumberField = $('#person_document_number');

    if (documentNumberField.length) {
      const personDocumentNumberValue = documentNumberField.val().replace(/[^\d]+/g, '');

      if (!validatePersonDocumentNumber(personDocumentNumberValue)) {
        $('.required-error').remove();
        documentNumberField.addClass('required-empty').after('<span class="required-error">CPF inválido</span>');
        event.preventDefault();
      }
    }
  });
});
