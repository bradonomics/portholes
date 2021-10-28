require 'nokogiri'
require 'down'
require 'fileutils'
require 'rack/mime'
require 'net/http'
require 'httparty'

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

    count = 1
    # Replace the src for downloaded images
    article.css('img').each do |img|
      # Make sure the image isn't a `data:image` as it will error on download
      next if img.attr('src').include? 'data:image/svg+xml'

      # Download the image with Down gem
      url = URI.parse(img.attr('src'))
      if HTTParty.get(url).response.code == '200' # Check that the image is avaliable (no 404s)
        image = Down.download(img.attr('src'))
        # Get the file extention
        image_type = Rack::Mime::MIME_TYPES.invert[image.content_type]
        # Rename the file for those idiots who like to string URLs together and break the internet
        image_name = "#{count.to_words}" + "#{image_type}"
        # Move the file to the appropriate directory
        FileUtils.mv(image.path, "#{full_directory_path}/#{file_name}/#{image_name}")
        # Update the `img` tag in the article body
        img.attributes['src'].value = "#{file_name}/#{image_name}"
      else
        # Copy the "no-image" file to the appropriate directory
        FileUtils.cp("app/assets/images/no-image.jpg", "#{full_directory_path}/#{file_name}/#{count.to_words}.jpg")
        # Update the `img` tag in the article body
        img.attributes['src'].value = "#{file_name}/#{count.to_words}.jpg"
      end

      count += 1
    end

    return article

  end

end
