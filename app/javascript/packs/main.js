import Rails from '@rails/ujs';

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

  // archive-all in navbar
  if (event.target == document.getElementById('archive-all')) {
    event.preventDefault();

    var folderId = document.getElementById('articles').dataset.folder;
    var articleIds = [];
    document.querySelectorAll('.article').forEach(item =>
      articleIds.push(item.dataset.id)
    );

    Rails.ajax({
      url: '/folder/' + folderId + '/archive-all',
      type: 'patch',
      data: 'articles=' + articleIds
    });

  }

});
