require 'httparty'
require 'nokogiri'
require 'uri'

module ArticlesHelper

  # Check that the article is returning a 200 status code.
  def check_http_status(url)
    if HTTParty.get(url).response.code == '200'
      return
    else
      raise FetchError, "Article not found. Check the URL and try again."
    end
  rescue HTTParty::Error => error
    raise FetchError, error.to_s
  rescue StandardError => error
    raise FetchError, error.to_s
  end

  # Get the title for displaying in the list.
  def get_title(url)
    request = HTTParty.get(url)
    title = Nokogiri::HTML(request.body).at_css("title").text
    h1 = Nokogiri::HTML(request.body).at_css("h1").text
    if title.present?
      return title
    elsif h1.present?
      return h1
    else
      return "No Title Found"
    end
  rescue HTTParty::Error => error
    raise FetchError, error.to_s
  rescue StandardError => error
    raise FetchError, error.to_s
  end

  def strip_utm_params(url)
    uri = URI.parse(url)
    # `URI.decode_www_form` will error if `uri.query` is blank, so check first.
    if uri.query.blank?
      return url
    else
      clean_key_vals = URI.decode_www_form(uri.query).reject { |k, _| k.start_with?('utm_' || 'sessionID') }
      uri.query = URI.encode_www_form(clean_key_vals)
      url = uri.to_s
      if url.end_with?("?")
        url.delete_suffix!("?")
      end
      return url
    end
  rescue StandardError => error
    raise FetchError, "#{error}"
  end

end
