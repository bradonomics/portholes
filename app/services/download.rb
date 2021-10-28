require 'uri'
require 'httparty'
require 'nokogiri'
require 'open3'
require 'fileutils'

class Download
  attr_reader :user_directory, :full_directory_path, :files

  def initialize(user, articles)
    @articles = articles
    # @directory = "tmp/#{user.hello_token}-#{DateTime.now.to_s.parameterize}"
    @user_directory = "public/downloads/#{user.hello_token}"
    @full_directory_path = "#{@user_directory}/#{DateTime.now.to_s.parameterize}"
    @files = []
  end

  def download
    Dir.mkdir("public/downloads") unless Dir.exists?("public/downloads")
    Dir.mkdir(@user_directory) unless Dir.exists?(@user_directory)
    FileUtils.rm_rf("#{@user_directory}/.", secure: true) # Remove previously downloaded files
    Dir.mkdir(@full_directory_path) unless Dir.exists?(@full_directory_path)

    @articles.order(:position).first(50).each do |url|
      # Get article HTML
      request = HTTParty.get(url.link)
      document = Nokogiri::HTML(request.body)
      # Get article hostname (domain name)
      host = URI.parse(url.link).host

      # Send document to Readability for parsing
      article, article_status = Open3.capture2("node lib/services/readability.js '#{url.link}'", stdin_data: document)

      # If Readability fails, use home-built parser
      # next unless article_status == 0
      document.to_html(:encoding => 'UTF-8')
      document.to_s
      article = ArticleParser.download(document) unless article_status == 0

      # Add title and file_name to files array
      title = url.title
      file_name = title.parameterize
      @files.push([url.title, file_name])

      # Download images and replace image src in article
      Dir.mkdir("#{@full_directory_path}/#{file_name}") unless Dir.exists?("#{@full_directory_path}/#{file_name}")
      article = ArticleParser.images(@full_directory_path, file_name, article)

      # Create a new file in `directory` with article contents
      ArticleWriter.write("#{@full_directory_path}/#{file_name}.html", article, title, host)
    end

  end

end
