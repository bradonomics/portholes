class ApplicationController < ActionController::Base

  add_flash_types :success, :warning, :error

  # Get the title for displaying in the list.
  # Unless you are bloomberg.com: https://github.com/metainspector/metainspector/issues/245
  # Use for testing: https://www.bloomberg.com/news/articles/2021-04-30/more-americans-are-considering-retirement-because-of-covid
  def get_title(url)
    page = MetaInspector.new(url, encoding: 'UTF-8')
    if page.title.present?
      return page.best_title
    else
      return "Document Title Not Found"
    end
  rescue MetaInspector::RequestError => error
    error_message = "Unable to save the article title."
    raise FetchError, "#{error_message}<br>#{error}"
  rescue StandardError => error
    raise FetchError, error.to_s
  end

  def strip_utm_params(url)
    # If there's no `http` it most likely means it was added from the #new action
    return unless url.include? 'http'

    # The below is from the `url=(u)` method in https://github.com/lobsters/lobsters/blob/master/app/models/story.rb
    uri = url.to_s
    if (uri.match(/\A([^\?]+)\?(.+)\z/))
      params = uri.split(/[&\?]/)
      uri = params.shift() # remove the first item in the params array
      params.reject! {|p| p.match(/^utm_(source|medium|campaign|term|content)=|^sk=|^fbclid=/) }
      url = uri << (params.any?? "?" << params.join("&") : "")
    end

    # The below is from: https://news.ycombinator.com/item?id=27048598
    # startswith: 'utm_', 'ga_', 'hmb_', 'ic_', 'fb_', 'pd_rd', 'ref_', 'share_', 'client_', 'service_'
    # or has: '$/ref@amazon.', '.tsrc', 'ICID', '_xtd', '_encoding@amazon.', '_hsenc', '_openstat', 'ab', 'action_object_map', 'action_ref_map', 'action_type_map', 'amp', 'arc404', 'affil', 'affiliate', 'app_id', 'awc', 'bfsplash', 'bftwuk', 'campaign', 'camp', 'cip', 'cmp', 'CMP', 'cmpid', 'curator', 'cvid@bing.com', 'efg', 'ei@google.', 'fbclid', 'fbplay', 'feature@youtube.com', 'feedName', 'feedType', 'form@bing.com', 'forYou', 'fsrc', 'ftcamp', 'ga_campaign', 'ga_content', 'ga_medium', 'ga_place', 'ga_source', 'ga_term', 'gi', 'gclid@youtube.com', 'gs_l', 'gws_rd@google.', 'igshid', 'instanceId', 'instanceid', 'kw@youtube.com', 'maca', 'mbid', 'mkt_tok', 'mod', 'ncid', 'ocid', 'offer', 'origin', 'partner','pq@bing.com', 'print', 'printable', 'psc@amazon.', 'qs@bing.com', 'rebelltitem', 'ref', 'referer', 'referrer', 'rss', 'ru', 'sc@bing.com', 'scrolla', 'sei@google.', 'sh', 'share', 'sk@bing.com', 'source', 'sp@bing.com', 'sref', 'srnd', 'supported_service_name', 'tag', 'taid', 'time_continue', 'tsrc', 'twsrc', 'twcamp', 'twclid', 'tweetembed', 'twterm', 'twgr', 'utm', 'ved@google.', 'via', 'xid', 'yclid', 'yptr'


    # How MetaInspector gem strips params:
    # https://github.com/metainspector/metainspector/blob/6304404c122573ea5c35a97587f2b9c674ff080b/lib/meta_inspector/url.rb#L27-L46

    if url.end_with?("?")
      url.delete_suffix!("?")
    end

    return url
  rescue StandardError => error
    raise FetchError, "#{error}"
  end

  def is_numeric?(string)
    string.scan(/\D/).empty?
  end

  private

    def require_signin
      unless current_user
        session[:intended_url] = request.url
        redirect_to signin_path, error: "You must log in to continue."
      end
    end

    def require_admin
      redirect_to root_url, error: "Unauthorized access." unless current_user_admin?
    end

    helper_method :current_user_admin?
    def current_user_admin?
      current_user && current_user.admin?
    end

end
