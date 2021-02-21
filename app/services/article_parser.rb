require 'nokogiri'

module ArticleParser

  def self.parse(document)

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

end
