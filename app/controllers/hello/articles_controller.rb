require 'httparty'
require 'nokogiri'
require 'uri'

module Hello
  class ArticlesController < ApplicationController

    protect_from_forgery except: :index
    after_action :set_access_control_headers

    def index
      @current_user = User.find_by_hello_token(params[:hello_token])
      render content_type: "text/javascript"
    end

    def create
      current_user = User.find_by_hello_token(params[:hello_token])
      clean_url = strip_utm_params(params[:link])
      # if link is already in database for this user, move it to home
      if current_user.articles.find_by_link(clean_url).present?
        @article = current_user.articles.find_by_link(clean_url)
        # Move the article in position 0 so this article can be in position 0
        first_article = current_user.articles.left_outer_joins(:folder).where(folder: { permalink: "Unread" }, position: 0)
        first_article.update(position: 1)
        folder = Folder.where(name: "Unread", user_id: current_user.id).first_or_create
        folder_id = folder.id
        @article.folder_id = folder_id
        @article.position = 0
      else
        @article = current_user.articles.new(link: clean_url)
        @article.user = current_user
        folder = Folder.where(name: "Unread", user_id: current_user.id).first_or_create
        folder_id = folder.id
        @article.folder_id = folder_id
        @article.title = get_title(clean_url)
        @article.position = current_user.articles.count
      end
      @article.save!
    end

    private

      def set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Request-Method'] = 'POST'
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

  end
end
