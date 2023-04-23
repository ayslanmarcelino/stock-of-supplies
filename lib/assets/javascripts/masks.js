$(document).on('turbo:load', function() {
  const Masks = {
    decimalPlacesMoney: 2,
    decimalPlacesPercent: 1,
    fixMoneyInputValues($, selector, decimalPlaces) {
      $(selector).each((n, el) => {
        const value = el.value;
        if (value) $(el).val(parseFloat(value).toFixed(decimalPlaces));
      });
    },

    documentNumberMask: (val) => {
      const formattedValLength = val.replace(/\D/g, '').length;
      return formattedValLength > 11 || !formattedValLength ? '00.000.000/0000-00' : '000.000.000-009';
    },

    onKeyPress: f => ({ onKeyPress: (val, e, field, options) => field.mask(f(val), options) })
  }

  Masks.fixMoneyInputValues($, '.input--money', Masks.decimalPlacesMoney);

  $('input[type=text].document_number').mask(Masks.documentNumberMask, Masks.onKeyPress(Masks.documentNumberMask));
  $('.input-cpf').mask('000.000.000-00', { reverse: true });
  $('.input-cnpj').mask('00.000.000/0000-00', { reverse: true });
  $('.input-telephone-number').mask('(00) 0000-0000');
  $('.input-cell-number').mask('(00) 00000-0000');
  $('.input-zip-code').mask('00000-000');
});
