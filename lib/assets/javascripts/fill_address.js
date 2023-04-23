$(document).on('turbo:load', function() {
  $('#zip_code').blur(function() {
    var zipCode = $(this).val();

    $.ajax({
      url: `https://viacep.com.br/ws/${zipCode}/json`,
      dataType: "jsonp",
      success: function(data) {
        $('#street').val(data.logradouro);
        $('#number').val('');
        $('#complement').val(data.complemento);
        $('#neighborhood').val(data.bairro);
        $('#city').val(data.localidade);
        $('#state').val(data.uf);
        $('#country').val('Brasil');

        $('input, select').prop('disabled', false);
        $('#country').prop('disabled', true);
  
        if (data.bairro.length) {
          $('#neighborhood').prop('disabled', true);
        }
  
        if (data.localidade.length) {
          $('#city').prop('disabled', true);
        }
  
        if (data.uf.length) {
          $('#state').prop('disabled', true);
        }
      }
    });
  });
});
