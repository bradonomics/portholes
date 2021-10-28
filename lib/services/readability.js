var fs = require('fs');
var { Readability } = require('@mozilla/readability');
var JSDOM = require('jsdom').JSDOM;
var fullUrl = process.argv.slice(2);

try {
  fs.readFile(0, 'utf8', function(err, data) {
    if (err) throw err;
    var doc = new JSDOM(data, { url: fullUrl });
    var article = new Readability(doc.window.document).parse();
    console.log(article.content);
  });
} catch (e) {
  console.log(e instanceof TypeError);
}
