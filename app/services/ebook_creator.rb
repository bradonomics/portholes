module EbookCreator
  def self.mobi(directory, ebook_file_name)
    system("zip -r #{directory}.zip #{directory}")
    system("ebook-convert #{directory}.zip tmp/#{ebook_file_name}.mobi --authors \"Portholes\" --no-inline-toc --chapter 'page' --change-justification 'left' --remove-paragraph-spacing --page-breaks-before '/'")
    system("rm #{directory}.zip")
    system("rm -rf #{directory}")
  end

  def self.epub(directory, ebook_file_name)
    system("zip -r #{directory}.zip #{directory}")
    system("ebook-convert #{directory}.zip tmp/#{ebook_file_name}.epub --authors \"Portholes\" --chapter 'page' --change-justification 'left' --remove-paragraph-spacing --page-breaks-before '/'")
    system("rm #{directory}.zip")
    system("rm -rf #{directory}")
  end
end
