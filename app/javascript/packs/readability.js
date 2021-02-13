// import Readability from '@mozilla/readability';
require('@mozilla/readability');

function articleBody(document) {
  var article = new Readability(document).parse();
  return article.content;
}
