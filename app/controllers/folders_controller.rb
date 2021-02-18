require 'httparty'
require 'nokogiri'

class FoldersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_folder, only: [:edit, :update, :destroy]

  # GET /folders
  # GET /folders.json
  # def index
  #   @folders = Folder.all
  # end

  # GET /folders/:permalink
  # GET /folders/:permalink.json
  def show
    folder_id = Folder.find_by_permalink(params[:permalink]).id
    @folder = Folder.find(folder_id)

    if params[:controller] == 'folders' && params[:action] == 'show' && params[:permalink] == 'archive'
      @articles = current_user.articles.left_outer_joins(:folder).where(folder: { permalink: params[:permalink] }).order(created_at: :desc)
    else
      @articles = current_user.articles.left_outer_joins(:folder).where(folder: { permalink: params[:permalink] }).order(position: :asc)
    end
  end

  # GET /folders/new
  # def new
  #   @folder = Folder.new
  # end

  # GET /folders/:permalink/edit
  # def edit
  # end

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
  # def update
  #   respond_to do |format|
  #     if @folder.update(folder_params)
  #       format.html { redirect_to @folder, notice: 'Folder was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @folder }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @folder.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH /folders/:permalink/sort
  def sort
    params[:articles].split(',').map.with_index do |id, position|
      current_user.articles.find_by_id(id).update_columns(position: position)
    end
    head :ok
  end

  # PATCH /articles/:id/archive-all
  def archive_all
    folder = Folder.where(name: "archive", user_id: current_user.id).first_or_create

    params[:articles].split(',').map.with_index do |id, position|
      current_user.articles.find_by_id(id).update_columns(folder_id: folder.id)
    end

    respond_to do |format|
      format.js {render inline: "location.reload();" }
    end

  end

  # GET /folders/:permalink/mobi
  def mobi
    folder_id = current_user.folders.find_by_permalink(params[:permalink]).id
    folder = Folder.find(folder_id)

    articles = current_user.articles.left_outer_joins(:folder).where(folder: folder)
    ebook = Download.new(current_user, articles)
    ebook.download
    TableOfContents.create("#{ebook.directory}/toc.html", ebook.files)
    ebook_file_name = "Portholes-#{folder.permalink}-#{Date.today.to_s}"
    EbookCreator.mobi(ebook.directory, ebook_file_name)
    ebook_file = File.join Rails.root, "tmp/#{ebook_file_name}.mobi"
    File.open(ebook_file, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), :filename => "#{ebook_file_name}.mobi", :type => "application/mobi", :disposition => "attachment"
    end
    File.delete(ebook_file)
  end

  # GET /folders/:permalink/epub
  def epub
    folder_id = current_user.folders.find_by_permalink(params[:permalink]).id
    folder = Folder.find(folder_id)

    articles = current_user.articles.left_outer_joins(:folder).where(folder: folder)
    ebook = Download.new(current_user, articles)
    ebook.download
    TableOfContents.create("#{ebook.directory}/toc.html", ebook.files)
    ebook_file_name = "Portholes-#{folder.permalink}-#{Date.today.to_s}"
    EbookCreator.epub(ebook.directory, ebook_file_name)
    ebook_file = File.join Rails.root, "tmp/#{ebook_file_name}.epub"
    File.open(ebook_file, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), :filename => "#{ebook_file_name}.epub", :type => "application/epub", :disposition => "attachment"
    end
    File.delete(ebook_file)
  end

  # DELETE /folders/:permalink
  # DELETE /folders/:permalink.json
  def destroy
    @folder.destroy
    respond_to do |format|
      format.html { redirect_to folders_url, notice: 'Folder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @folder = Folder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def folder_params
      params.require(:folder).permit(:name, :permalink, :user_id)
    end
end
