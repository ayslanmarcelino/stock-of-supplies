$(document).on('turbo:load', function() {
  var canvas = document.getElementById('chart');
  if (canvas) {
    const getRandomColor = () => {
      const letters = '0123456789ABCDEF';
      let color = '#';
      for (let i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
      }
      return color;
    };
    const ctx = canvas.getContext('2d');
    const labels = $('#chart').data('labels');
    const values = $('#chart').data('values')?.filter(value => value >= 0) ?? [];
    const randomColors = Array.from({ length: values.length }, () => getRandomColor());

    new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels,
        datasets: [{
          label: 'Quantidade',
          data: values,
          backgroundColor: randomColors,
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true
      }
    });
  }
});
