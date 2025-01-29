document.addEventListener('DOMContentLoaded', function() {
  const dropdownButton = document.getElementById('dropdownButton');
  const dropdownMenu = document.getElementById('dropdownMenu');
  const dropdownContainer = document.getElementById('userDropdown');

  if (dropdownButton && dropdownMenu) {
    // Toggle dropdown when clicking the button
    dropdownButton.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      dropdownMenu.classList.toggle('hidden');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
      if (!dropdownContainer.contains(e.target)) {
        dropdownMenu.classList.add('hidden');
      }
    });

    // Close dropdown when pressing Escape key
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') {
        dropdownMenu.classList.add('hidden');
      }
    });
  }
}); 