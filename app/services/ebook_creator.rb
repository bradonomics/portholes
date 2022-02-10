require 'fileutils'

module EbookCreator
  def self.kindle(current_user, user_directory, full_directory_path, ebook_file_name, folder)
    mobi_file_type = ''
    if current_user.ebook_preference == 'new_mobi'
      book_format = 'mobi'
      mobi_file_type = "--mobi-file-type 'new'"
    elsif current_user.ebook_preference == 'old_mobi'
      book_format = 'mobi'
    elsif current_user.ebook_preference == 'azw'
      book_format = 'azw3'
    end

    date = Date.today
    system("zip -r #{full_directory_path}.zip #{full_directory_path}")
    system("ebook-convert #{full_directory_path}.zip #{user_directory}/#{ebook_file_name}.#{book_format} --authors \"Portholes\" --no-inline-toc --chapter 'page' --title \"#{folder.name}: #{date.strftime('%a, %d %b %Y')}\" --change-justification 'left' --page-breaks-before '/' #{mobi_file_type}")
    File.delete("#{full_directory_path}.zip")
    FileUtils.rm_r(full_directory_path)
  end

  def self.epub(current_user, user_directory, full_directory_path, ebook_file_name, folder)
    date = Date.today
    system("zip -r #{full_directory_path}.zip #{full_directory_path}")
    system("ebook-convert #{full_directory_path}.zip #{user_directory}/#{ebook_file_name}.epub --authors \"Portholes\" --chapter 'page' --title \"#{folder.name}: #{date.strftime('%a, %d %b %Y')}\" --change-justification 'left' --page-breaks-before '/'")
    File.delete("#{full_directory_path}.zip")
    FileUtils.rm_r(full_directory_path)
  end
end
