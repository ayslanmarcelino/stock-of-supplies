import Rails from 'rails-ujs';

const confirmed = ($element, result) => {
  if (result.value) {
    const confirm = $element.data('confirm');

    $element.removeAttr('data-turbo-confirm');
    $element[0].click();
    $element.attr('data-confirm', confirm);
  }
};

const handleConfirmationResult = ($element, result) => {
  if (!result.value) return;
  confirmed($element, result);
};

const showConfirmationDialog = ($element) => {
  const message = $element.data('turbo-confirm');
  const text = $element.data('text');
  const confirmButton = $element.data('confirmButton');

  const customSwal = Swal.mixin({
    reverseButtons: true
  })

  customSwal.fire({
    title: message || 'Você tem certeza?',
    text: text || '',
    icon: 'warning',
    showCancelButton: true,
    cancelButtonText: 'Cancelar',
    confirmButtonText: confirmButton || 'Sim',
    confirmButtonColor: "#24a0ed",
  }).then(result => handleConfirmationResult($element, result));
};

const allowAction = (element) => {
  const $element = $(element);
  if ($element.data('turbo-confirm')) {
    showConfirmationDialog($element);
    return false;
  }

  return true;
};

function handleConfirm(element) {
  if (!allowAction(this)) {
    Turbo.setConfirmMethod(element);
  }
}

Rails.delegate(document,
               'a[data-turbo-confirm], input[data-turbo-confirm]',
               'click',
               handleConfirm);
Rails.delegate(document, 'submit', handleConfirm);
