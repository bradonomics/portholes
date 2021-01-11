class ArticlesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :set_article_from_permalink, only: [:archive, :unarchive]

  # GET /articles
  # GET /articles.json
  # def index
  #   @articles = Article.all
  # end

  # GET /articles/1
  # GET /articles/1.json
  # def show
  # end

  # GET /articles/new
  # def new
  #   @article = Article.new
  # end

  # GET /articles/1/edit
  # def edit
  # end

  # POST /articles
  # POST /articles.json
  def create
    check_http_status(article_params[:link].to_s)
    clean_url = strip_utm_params(article_params[:link].to_s)
    # if link is already in database for this user, move it to home
    if current_user.articles.find_by_link(clean_url).present?
      @article = current_user.articles.find_by_link(clean_url)
      # Move the article in position 0 so this article can be in position 0
      first_article = current_user.articles.left_outer_joins(:folder).where(folder: { permalink: params[:permalink] }, position: 0)
      first_article.update(position: 1)
      folder = Folder.find_by_name(params[:folder])
      folder_id = folder.id
      @article.folder_id = folder_id
      @article.position = 0
      @article.save!
      redirect_back(fallback_location: folder_path)
    else
      @article = current_user.articles.new(article_params)
      @article.user = current_user
      folder = Folder.find_by_name(params[:folder])
      folder_id = folder.id
      @article.folder_id = folder_id
      @article.title = get_title(@article.link)
      @article.position = current_user.articles.count
      @article.save!
      redirect_back(fallback_location: folder_path, success: "Article saved.")
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    if @article.errors.include?(:link)
      redirect_to folder_path, warning: @article.errors.full_message(:link, 'already saved.')
    else
      redirect_to folder_path, error: "Failed to save article.<br>ActiveRecord, not :link, error<br>#{@article.errors.full_messages}"
    end
  rescue FetchError => error
    redirect_to folder_path, error: "Article not found. Check the URL and try again.<br>#{error}"
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /articles/1/archive
  def archive
    current_user.articles.left_outer_joins(:folder).where(folder: { name: "archive" }, position: 0).update(position: 1)
    @article.position = 0
    folder = Folder.where(name: "archive", user_id: current_user.id).first_or_create
    @article.folder_id = folder.id
    @article.save!
    redirect_back(fallback_location: folder_path)
    # redirect_to folder_path # TODO: This needs to redirect_to where the user was not the folder_path
  end

  # PATCH /articles/1/unarchive
  def unarchive
    current_user.articles.left_outer_joins(:folder).where(folder: { name: "inbox" }, position: 0).update(position: 1)
    @article.position = 0
    folder = Folder.where(name: "inbox", user_id: current_user.id).first_or_create
    @article.folder_id = folder.id
    @article.save!
    redirect_back(fallback_location: folder_path)
    # redirect_to folder_path # TODO: This needs to redirect_to where the user was not the folder_path
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    redirect_back(fallback_location: folder_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = current_user.articles.find(params[:id])
    end

    def set_article_from_permalink
      article = Article.find_by_permalink(params[:id])
      article_id = article.id
      @article = current_user.articles.find(article_id)
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :link, :position, :user_id, :folder_id)
    end

end
