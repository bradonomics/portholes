require 'csv'

class Article < ApplicationRecord

  belongs_to :user
  belongs_to :folder

  validates :title, presence: true
  validates :link, presence: true, uniqueness: { scope: :user_id }

  # def self.to_csv
  #   CSV.generate(headers: true) do |csv|
  #     csv << ['URL', 'Title', 'Selection', 'Folder', 'Timestamp']
  #     all.each do |article|
  #       csv << [article.link, article.title, nil, article.folder.name, article.created_at.to_i]
  #     end
  #   end
  # end

  # The below is used for exporting to a non-Instapaper system

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ['source_url', 'title', 'body', 'folder_id', 'created_at']
      all.each do |article|
        if article.folder.name == 'Unread'
          csv << [article.link, article.title, article.body, '1', article.created_at]
        elsif article.folder.name == 'Archive'
          csv << [article.link, article.title, article.body, '2', article.created_at]
        elsif article.folder.name == 'Dyslexia'
          csv << [article.link, article.title, article.body, '3', article.created_at]
        elsif article.folder.name == 'Dyslexia Archive'
          csv << [article.link, article.title, article.body, '4', article.created_at]
        elsif article.folder.name == 'Health Care'
          csv << [article.link, article.title, article.body, '5', article.created_at]
        elsif article.folder.name == 'Story Club'
          csv << [article.link, article.title, article.body, '6', article.created_at]
        elsif article.folder.name == 'Global Training Report'
          csv << [article.link, article.title, article.body, '7', article.created_at]
        end
      end
    end
  end

end
