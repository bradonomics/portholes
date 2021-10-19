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
      return unless subscriber?

      current_user = User.find_by_hello_token(params[:hello_token])
      # TODO: find_by_hello_token should be changed. Something more secure like
      # current_user = User.find_by_session_id(session[:user_id])
      # Except find_by_session_id doesn't work if they're
      # not logged in. So a redirect to login would be needed.

      clean_url = strip_utm_params(params[:link])
      # if link is already in database for this user, move it to home
      if current_user.articles.find_by_link(clean_url).present?
        @article = current_user.articles.find_by_link(clean_url)
        # Move the article in position 0 so this article can be in position 0
        first_article = current_user.articles.left_outer_joins(:folder).where(folder: { permalink: "unread" }, position: 0)
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
        @article.body = ArticleFetch.download(@article)
        @article.position = current_user.articles.count
      end
      @article.save!
    end

    private

      def set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Request-Method'] = 'POST'
      end

  end
end
