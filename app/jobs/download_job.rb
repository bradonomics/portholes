class DownloadJob < ApplicationJob
  queue_as :default
  # attr_reader :ebook, :ebook_file

  def perform(current_user, folder)
    articles = current_user.articles.left_outer_joins(:folder).where(folder: folder)
    ebook = Download.new(current_user, articles)
    ebook.download
    TableOfContents.create("#{ebook.full_directory_path}/toc.html", ebook.files)
    ebook_file_name = "Portholes-#{folder.permalink}-#{Date.today.to_s}"
    if current_user.ebook_preference == 'epub'
      EbookCreator.epub(ebook.user_directory, ebook.full_directory_path, ebook_file_name)
    else
      EbookCreator.mobi(ebook.user_directory, ebook.full_directory_path, ebook_file_name)
    end
  end
end
