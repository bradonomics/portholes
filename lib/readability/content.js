var fs = require('fs');
var { Readability } = require('@mozilla/readability');
var JSDOM = require('jsdom').JSDOM;

try {
  fs.readFile(0, 'utf8', function(err, data) {
    if (err) throw err;
    var doc = new JSDOM(data);
    var article = new Readability(doc.window.document).parse();
    console.log(article.content);
  });
} catch (e) {
  console.log(e instanceof TypeError);
}
