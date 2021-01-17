class FoldersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_folder, only: [:edit, :update, :destroy]

  # GET /folders
  # GET /folders.json
  def index
    @folders = Folder.all
  end

  # GET /folders/1
  # GET /folders/1.json
  def show
    folder_id = Folder.find_by_permalink(params[:permalink]).id
    @folder = Folder.find(folder_id)
    @articles = current_user.articles.left_outer_joins(:folder).where(folder: { permalink: params[:permalink] })
  end

  # GET /folders/new
  def new
    @folder = Folder.new
  end

  # GET /folders/1/edit
  def edit
  end

  # POST /folders
  # POST /folders.json
  # def create
  #   @folder = Folder.new(folder_params)
  #
  #   respond_to do |format|
  #     if @folder.save
  #       format.html { redirect_to @folder, notice: 'Folder was successfully created.' }
  #       format.json { render :show, status: :created, location: @folder }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @folder.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

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

  # PATCH /folders/1/sort
  def sort
    params[:articles].split(',').map.with_index do |id, position|
      current_user.articles.find_by_id(id).update_columns(position: position)
    end
    head :ok
  end

  # GET /folders/1/download
  def download
    folder_id = Folder.find_by_permalink(params[:id]).id
    folder = Folder.find(folder_id)

    articles = current_user.articles.left_outer_joins(:folder).where(folder: folder)
    ebook = Download.new(articles)
    ebook.download
    TableOfContents.create("#{ebook.directory}/toc.html", ebook.files)
    EbookCreator.mobi(ebook.directory)
    ebook_file = File.join Rails.root, "#{ebook.directory}.mobi"
    File.open(ebook_file, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), :filename => "brad.mobi", :type => "application/mobi", :disposition => "attachment"
    end
    File.delete(ebook_file)
  end

  # DELETE /folders/1
  # DELETE /folders/1.json
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
