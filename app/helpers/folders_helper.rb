module FoldersHelper

  def downloadable_folder?
    return true if params[:controller] == 'folders' && params[:action] == 'show' && request.path != '/folder/archive'
  end

  def default_folder?
    return true if request.path == '/folder/unread' || request.path == '/folder/archive'
  end

  def sidebar_folders
    current_user.folders.where.not(name: ["Unread","Archive"])
  end

end
