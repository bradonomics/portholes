// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// BRAD: When you forget how this horseshit works, read this: https://stackoverflow.com/questions/56128114/using-rails-ujs-in-js-modules-rails-6-with-webpacker

import Rails from '@rails/ujs';
import Sortable from 'sortablejs';
import Turbolinks from 'turbolinks';
import * as ActiveStorage from '@rails/activestorage';
import 'channels';
require('packs/navigation');
require('packs/modals');
require('packs/archive-all');
require('packs/sort-articles');

Rails.start();
Turbolinks.start();
ActiveStorage.start();

// document.addEventListener('turbolinks:load', () => {
// });
