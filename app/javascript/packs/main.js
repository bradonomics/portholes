// Watch for clicks
document.addEventListener('click', function(event) {

  // add-link in navigation
  if (event.target == document.getElementById('add-link')) {
    event.preventDefault();
    modal('add-link-modal');
  }

  // download in navbar
  if (event.target == document.getElementById('download')) {
    event.preventDefault();
    modal('download-modal');
  }

});
