module FoldersHelper

  def downloadable_folder?
    if params[:controller] == 'folders' && request.path != '/folder/archive'
      return true
    end
  end

end
