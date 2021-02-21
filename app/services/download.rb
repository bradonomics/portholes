require 'uri'
require 'httparty'
require 'nokogiri'
require 'open3'

class Download
  attr_reader :directory
  attr_reader :files

  def initialize(user, articles)
    @articles = articles
    @directory = "tmp/#{user.hello_token}-#{DateTime.now.to_s.parameterize}"
    @files = []
  end

  def download
    unless File.exists?(@directory)
      Dir.mkdir @directory
    end

    @articles.order(:position).each do |url|
      # Get article HTML
      request = HTTParty.get(url.link)
      document = Nokogiri::HTML(request.body)

      # Send document to Readability for parsing
      article, article_status = Open3.capture2("node lib/readability/content.js", stdin_data: document)

      # If Readability fails, use home-built parser
      # next unless article_status == 0
      document.to_html(:encoding => 'UTF-8')
      document.to_s
      article = ArticleParser.parse(document) unless article_status == 0

      # Add title and file_name to files array
      title = url.title
      file_name = title.parameterize
      @files.push([url.title, file_name])

      host = URI.parse(url.link).host

      # Create a new file in `directory` with article contents
      ArticleWriter.write("#{@directory}/#{file_name}.html", article, title, host)
    end

  end

end
