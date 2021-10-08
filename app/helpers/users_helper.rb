module UsersHelper

  def have_downloads?
    Dir.glob("#{Rails.public_path}/downloads/#{current_user.hello_token}/*.mobi").any?
  end

  def ebook_file_name
    if have_downloads?
      array = Dir["#{Rails.public_path}/downloads/#{current_user.hello_token}/*"]
      return array[0].split('/').last
    end
  end

  def ebook_download
    array = Dir["#{Rails.public_path}/downloads/#{current_user.hello_token}/*"]
    file_path = array[0].split('/').last
    return "#{root_url}downloads/#{current_user.hello_token}/#{file_path}"
  end

end
