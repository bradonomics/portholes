module EbookCreator
  def self.mobi(directory)
    system("zip -r #{directory}.zip #{directory}")
    system("ebook-convert #{directory}.zip #{directory}.mobi --no-inline-toc --change-justification 'left'")
    system("rm #{directory}.zip")
    system("rm -rf #{directory}")
  end

  def self.epub(target_file, files)
  end
end
