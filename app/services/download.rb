require 'httparty'
require 'nokogiri'

class Download
  attr_reader :directory
  attr_reader :files

  def initialize(articles)
    @articles = articles
    # TODO: eventually this should be something like username-date
    @directory = "tmp/brad"
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

      # Add title and file_name to files array
      file_name = url.title.parameterize
      @files.push([url.title, file_name])

      # Parse article
      article = ArticleParser.parse(document)

      # Create a new file in `directory` with article contents
      ArticleWriter.write("#{@directory}/#{file_name}.html", article, url.title)
    end

  end

end
