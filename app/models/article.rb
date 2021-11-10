require 'csv'

class Article < ApplicationRecord

  before_save :set_permalink

  belongs_to :user
  belongs_to :folder

  validates :title, presence: true
  validates :link, presence: true, uniqueness: { scope: :user_id }

  def to_param
    permalink
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ['URL', 'Title', 'Selection', 'Folder', 'Timestamp']
      all.each do |article|
        csv << [article.link, article.title, nil, article.folder.name, article.created_at.to_i]
      end
    end
  end

  private

    def set_permalink
      if title.parameterize.blank?
        self.permalink = title
        # If the above turns out to be a poor choice, this is how you can get an encoded URL:
        # file_name = Addressable::URI.encode(title)
      else
        self.permalink = title.parameterize
      end
    end

end
