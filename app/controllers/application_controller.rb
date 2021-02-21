class ApplicationController < ActionController::Base

  add_flash_types :success, :warning, :error

  # Get the title for displaying in the list.
  def get_title(url)
    page = MetaInspector.new(url)
    if page.title.present?
      return page.best_title
    else
      return "Document Title Not Found"
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
      clean_key_vals = URI.decode_www_form(uri.query).reject { |k, _| k.start_with?('utm_' || 'sessionID' || 'ref') }
      # TODO: How to strip anchor links (#this-thing)?
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

  private

    def require_signin
      unless current_user
        session[:intended_url] = request.url
        redirect_to signin_path, error: "You must sign in to continue."
      end
    end

    def require_admin
      redirect_to root_url, error: "Unauthorized access." unless current_user_admin?
    end

    def current_user_admin?
      current_user && current_user.admin?
    end

    helper_method :current_user_admin?

end
