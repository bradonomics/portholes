module FoldersHelper

  def downloadable_folder?
    if params[:controller] == 'folders' && request.path != '/folder/archive'
      return true
    end
  end

  def sidebar_folders
    current_user.folders.where.not(name: ["Unread","Archive"])
  end

end
