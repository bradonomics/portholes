require 'uri'

module ApplicationHelper
  include Pagy::Frontend

  def inline_svg(path)
    file = File.open("app/assets/images/#{path}", "rb")
    raw file.read
  end

  def url_only(url)
    URI.parse(url).host
  end

end
