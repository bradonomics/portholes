require 'httparty'
require 'nokogiri'

class FoldersController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_folder, only: [:edit, :update, :destroy]

  # GET /folders
  # GET /folders.json
  def index
    @folders = Folder.where.not(permalink: 'unread').where.not(permalink: 'archive')
  end

  # GET /folders/:permalink
  # GET /folders/:permalink.json
  def show
    folder_id = Folder.find_by_permalink(params[:permalink]).id
    @folder = Folder.find(folder_id)

    if params[:controller] == 'folders' && params[:action] == 'show' && params[:permalink] == 'archive'
      @pagy, @articles = pagy(current_user.articles.left_outer_joins(:folder).where(folder: { permalink: params[:permalink] }).order(created_at: :desc), items: 20)
    else
      # @pagy, @folders = pagy(Folder.all, items: 20)
      @pagy, @articles = pagy(current_user.articles.left_outer_joins(:folder).where(folder: { permalink: params[:permalink] }).order(position: :asc), items: 20)
    end
  end

  # GET /folders/new
  # def new
  #   @folder = Folder.new
  # end

  # GET /folders/:permalink/edit
  def edit
    render
  end

  # POST /folders
  # POST /folders.json
  def create
    @folder = Folder.new
    @folder.user_id = current_user.id
    @folder.name = params[:name]
    @folder.save!
    redirect_back(fallback_location: folder_path("unread"))
  end

  # PATCH/PUT /folders/1
  # PATCH/PUT /folders/1.json
  def update
    respond_to do |format|
      if @folder.update(folder_params)
        format.html { redirect_to @folder, notice: 'Folder was successfully updated.' }
        format.json { render :show, status: :ok, location: @folder }
      else
        format.html { render :edit }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /folders/:permalink/sort
  def sort
    params[:articles].split(',').map.with_index do |id, position|
      current_user.articles.find_by_id(id).update_columns(position: position)
    end
    head :ok
  end

  # PATCH /articles/:id/archive-all
  def archive_all
    archive_folder = Folder.where(name: "Archive", user_id: current_user.id).first_or_create

    params[:articles].split(',').map.with_index do |id, position|
      current_user.articles.find_by_id(id).update_columns(folder_id: archive_folder.id)
    end

    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end

  end

  # GET /folders/:permalink/download
  def download
    # folder_id = current_user.folders.find_by_permalink(params[:permalink]).id
    folder = Folder.find(current_user.folders.find_by_permalink(params[:permalink]).id)


    # DownloadJob.perform_later(current_user, folder)


    articles = current_user.articles.left_outer_joins(:folder).where(folder: folder)
    ebook = Download.new(current_user, articles)
    ebook.download
    TableOfContents.create("#{ebook.full_directory_path}/toc.html", ebook.files)
    ebook_file_name = "Portholes-#{folder.permalink}-#{Date.today.to_s}"
    EbookCreator.mobi(ebook.user_directory, ebook.full_directory_path, ebook_file_name)




    redirect_to edit_user_registration_path, notice: 'Your download is processing. You will need to refresh to see it in the downloads section below.'
  end

  # DELETE /folders/:permalink
  # DELETE /folders/:permalink.json
  def destroy
    archive_folder = Folder.where(name: "Archive", user_id: current_user.id).first_or_create

    unless @folder.articles.empty?
      @folder.articles.split(',').map.with_index do |id, position|
        current_user.articles.find_by_id(id).update_columns(folder_id: archive_folder.id)
      end
    end

    @folder.destroy
    respond_to do |format|
      format.html { redirect_to folder_path("unread"), notice: "The folder \"#{@folder.name}\" has been deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @folder = Folder.find_by_permalink(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def folder_params
      params.require(:folder).permit(:name, :permalink, :user_id)
    end
end
