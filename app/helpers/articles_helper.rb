module ArticlesHelper

  def get_name_from_permalink(permalink)
    current_user.folders.find_by_permalink(permalink).name
  end

end
