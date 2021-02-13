import Rails from '@rails/ujs';
import Sortable from 'sortablejs';

window.onload = function() {

  // Article Sort Function
  var sortable = Sortable.create(document.getElementById('articles'), {
    handle: '.sort',
    animation: 100,
    ghostClass: 'moving-background',

    onEnd: function (event) { // element dragging ended

      var folderId = document.getElementById('articles').dataset.folder;
      var articleIds = [];
      document.querySelectorAll('.article').forEach(item =>
        articleIds.push(item.dataset.id)
      );

      Rails.ajax({
        url: '/folder/' + folderId + '/sort',
        type: 'patch',
        data: 'articles=' + articleIds
      });

    }

  });

};
