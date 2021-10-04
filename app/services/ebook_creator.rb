require 'fileutils'

module EbookCreator
  def self.mobi(user_directory, full_directory_path, ebook_file_name)
    system("zip -r #{full_directory_path}.zip #{full_directory_path}")
    system("ebook-convert #{full_directory_path}.zip #{user_directory}/#{ebook_file_name}.mobi --authors \"Portholes\" --no-inline-toc --chapter 'page' --change-justification 'left' --page-breaks-before '/'")
    File.delete("#{full_directory_path}.zip")
    FileUtils.rm_r(full_directory_path)
  end

  def self.epub(user_directory, full_directory_path, ebook_file_name)
    system("zip -r #{full_directory_path}.zip #{full_directory_path}")
    system("ebook-convert #{full_directory_path}.zip #{user_directory}/#{ebook_file_name}.epub --authors \"Portholes\" --chapter 'page' --change-justification 'left' --page-breaks-before '/'")
    File.delete("#{full_directory_path}.zip")
    FileUtils.rm_r(full_directory_path)
  end
end
