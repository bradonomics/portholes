require 'uri'
require 'httparty'
require 'nokogiri'
require 'open3'
require 'fileutils'

class Download
  attr_reader :user_directory, :full_directory_path, :files

  def initialize(user, articles)
    @articles = articles
    @user_directory = "public/downloads/#{user.hello_token}"
    @full_directory_path = "#{@user_directory}/#{DateTime.now.to_s.parameterize}"
    @files = [] # Used in services/table_of_contents.rb
  end

  def download
    Dir.mkdir("public/downloads") unless Dir.exists?("public/downloads")
    Dir.mkdir(@user_directory) unless Dir.exists?(@user_directory)
    FileUtils.rm_rf("#{@user_directory}/.", secure: true) # Remove previously downloaded files
    Dir.mkdir(@full_directory_path) unless Dir.exists?(@full_directory_path)

    @articles.order(:position).first(50).each do |url|
      article = url.body

      # Get article hostname (domain name)
      host = URI.parse(url.link).host

      # Add title and file_name to files array
      title = url.title
      if title.parameterize.blank?
        file_name = title
        # If the above turns out to be a poor choice, this is how you can get an encoded URL:
        # file_name = Addressable::URI.encode(title)
      else
        file_name = title.parameterize
      end
      @files.push([title, file_name])

      # Download images and replace image src in article
      Dir.mkdir("#{@full_directory_path}/#{file_name}") unless Dir.exists?("#{@full_directory_path}/#{file_name}")
      article = ArticleParser.images(@full_directory_path, file_name, article)

      # Create a new file in `directory` with article contents
      ArticleWriter.write("#{@full_directory_path}/#{file_name}.html", article, title, host)
    end

  end

end
