$(document).on('turbo:load', function() {
  var dropdown = document.getElementsByClassName('dropdown-btn');

  for (i = 0; i < dropdown.length; i++) {
    dropdown[i].addEventListener('click', function() {
      this.classList.toggle('active');
      var dropdownContent = this.nextElementSibling;
      var icon = document.getElementById('icon-dropdown');

      if (dropdownContent.style.display === 'block') {
        icon.classList.add('bi-caret-down');
        icon.classList.remove('bi-caret-up');
        dropdownContent.style.display = 'none';
      } else {
        icon.classList.add('bi-caret-up');
        icon.classList.remove('bi-caret-down');
        dropdownContent.style.display = 'block';
      }
    });
  }
});
