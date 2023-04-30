$(document).on('turbo:load', function() {
  const supplySelect = document.querySelector('#supply');
  const stockSelect = document.querySelector('#stock_select');
  const stockLabel = document.querySelector('#stock_label');
  const amountLabel = document.querySelector('#amount_label');
  const amountInput = document.querySelector('#amount_input');
  let stocks = [];

  stockSelect.style.display = 'none';
  stockLabel.style.display = 'none';
  amountLabel.style.display = 'none';
  amountInput.style.display = 'none';

  supplySelect.addEventListener('change', () => {
    const supplyId = supplySelect.value;

    fetch(`/supplies/${supplyId}/stocks.json`)
      .then(response => response.json())
      .then(data => {
        stocks = data;
        stockSelect.innerHTML = '<option value="">Selecione um lote</option>';
        stocks.forEach(stock => {
          const option = document.createElement('option');
          option.value = stock.id;
          option.text = `${stock.identifier} - Disponíveis: ${stock.remaining}`;
          stockSelect.appendChild(option);
        });

        stockLabel.style.display = 'block';
        stockSelect.style.display = 'block';
      });
  });

  stockSelect.addEventListener('change', () => {
    amountLabel.style.display = 'block';
    amountInput.style.display = 'block';
  });

  const form = document.querySelector('#order-form');

  form.addEventListener('submit', (event) => {
    const selectedStockId = stockSelect.value;
    const selectedStock = stocks.find(stock => stock.id == selectedStockId);
    const selectedAmount = amountInput.value;

    if (selectedAmount > selectedStock.remaining) {
      event.preventDefault();
      Swal.fire({
        title: 'Atenção!',
        text: 'A quantidade selecionada é maior do que a quantidade disponível em estoque.',
        icon: 'warning',
        confirmButtonColor: "#24a0ed"
      });
    }
  });
});
