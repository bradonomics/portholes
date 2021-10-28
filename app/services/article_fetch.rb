require 'uri'
require 'httparty'
require 'nokogiri'
require 'open3'

module ArticleFetch

  def self.download(article)

    # Get article HTML
    request = HTTParty.get(article.link)
    document = Nokogiri::HTML(request.body)

    # Send document to Readability for parsing
    article, article_status = Open3.capture2("node lib/services/readability.js '#{article.link}'", stdin_data: document)

    # next unless article_status == 0
    # If Readability fails, use home-built parser
    document.to_html(:encoding => 'UTF-8')
    document.to_s
    article = ArticleParser.download(document) unless article_status == 0

    return article.to_s

  end

end
