import Rails from '@rails/ujs';

// Watch for clicks
document.addEventListener('click', function(event) {

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
