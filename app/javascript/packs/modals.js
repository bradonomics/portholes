// Watch for clicks
document.addEventListener('click', function(event) {

  // add-link
  if (event.target == document.getElementById('add-link')) {
    event.preventDefault();
    modal('add-link-modal');
    document.querySelector('.article-add__input').focus();
  }

  // download in navigation
  if (event.target == document.getElementById('download')) {
    event.preventDefault();
    modal('download-modal');
  }

});

// Main Modal Function
window.modal = function(id) {
  var modal = document.getElementById(id);
  var close = document.querySelectorAll('[data-close="true"]');
  modal.style.display = 'block';
  for (var i = 0; i < close.length; i++) {
    close[i].onclick = function() {
      modal.style.display = 'none';
    };
  }
  window.onclick = function(e) {
    if (e.target == modal) {
      modal.style.display = 'none';
    }
  };
  document.onkeydown = function(e) {
    if (e.keyCode == 27) {
      modal.style.display = 'none';
    }
  };
};
