require 'uri'

module ApplicationHelper

  def inline_svg(path)
    file = File.open("app/assets/images/#{path}", "rb")
    raw file.read
  end

  def url_only(url)
    URI.parse(url).host
  end

end
