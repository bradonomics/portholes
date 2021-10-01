require 'nokogiri'
require 'down'
require 'fileutils'

module ArticleParser

  def self.download(document)

    # TODO: Could we use the print version should a site have one? Try World Hum.

    # Find article content
    if document.at_css("article")
      article = document.at_css("article")
    elsif document.at_css("main")
      article = document.at_css("main")
    elsif document.at_css('[id="content"]')
      article = document.at_css('[id="content"]')
    else
      article = document.at_css("body")
    end

    # Remove unwanted HTML elements
    article.search('aside', 'script', 'noscript', 'style', 'nav', 'video', 'form', 'button', 'fbs-ad', 'map').remove

    # Remove unwanted elements by class/id
    # TODO: make case insensitive to shorten file length
    file = File.join Rails.root, 'lib', 'stop_words.txt'
    File.readlines(file, chomp: true).each do |line|
      article.xpath("//*[@*[contains(., '#{line}')]]").each do |node|
        node.remove
      end
    end

    return article

  end

  def self.images(full_directory_path, file_name, document)

    # Tell nokogiri this is not a whole document
    article = Nokogiri::HTML::DocumentFragment.parse(document)

    # Replace the src for downloaded images
    article.css('img').each do |img|
      file = Down.download(img.attr('src'))
      FileUtils.mv(file.path, "#{full_directory_path}/#{file_name}/#{file.original_filename}")
      img.attributes['src'].value = "#{file_name}/#{file.original_filename}"
    end

    return article

  end

end
