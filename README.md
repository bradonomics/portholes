# Portholes

Portholes is a replacement for Instapaper or Pocket. The main differences are article sorting and a better parser.

## Article Parsing

[Mozilla's Readability library](https://github.com/mozilla/readability) is the main parser. You can see the call in [/app/services/article_fetch.rb](https://github.com/bradonomics/portholes/blob/master/app/services/article_fetch.rb). Should Mozilla's Readability library fail, I've written a [basic parser](https://github.com/bradonomics/portholes/blob/master/app/services/article_parser.rb) as a fall back.

## Ebook Creation

Portholes uses Calibre's `ebook-convert` to create .mobi and .epub files as seen in [/app/services/ebook_creator.rb](https://github.com/bradonomics/portholes/blob/master/app/services/ebook_creator.rb).

## Screenshots

Folder view:

![](https://github.com/bradonomics/portholes/blob/master/screenshots/folder.jpg)

Single article view:

![](https://github.com/bradonomics/portholes/blob/master/screenshots/article-single.jpg)

Settings:

![](https://github.com/bradonomics/portholes/blob/master/screenshots/settings.jpg)

## License

Use of Portholes is governed by the GNU AGPLv3 license that can be found in the [LICENSE](https://github.com/bradonomics/portholes/blob/master/LICENSE) file.
