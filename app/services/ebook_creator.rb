module EbookCreator
  def self.mobi(directory, ebook_file_name)
    system("zip -r #{directory}.zip #{directory}")
    system("ebook-convert #{directory}.zip #{ebook_file_name}.mobi --authors \"Portholes\" --no-inline-toc --change-justification 'left'")
    system("rm #{directory}.zip")
    system("rm -rf #{directory}")
  end

  def self.epub(target_file, files)
  end
end
