require 'uri'

module ApplicationHelper
  include Pagy::Frontend

  def stripe_page
    if user_signed_in?
      return true if (current_user.subscriber && current_page?(edit_user_registration_url)) || (current_user.created_at < 2.weeks.ago && current_user.subscriber == false) || current_user.created_at > 2.weeks.ago
    end
  end

  def inline_svg(path)
    file = File.open("app/assets/images/#{path}", "rb")
    raw file.read
  end

  def url_only(url)
    URI.parse(url).host
  end

end
