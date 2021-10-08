class Folder < ApplicationRecord

  before_save :set_permalink

  before_destroy :destroy_articles
  belongs_to :user
  has_many :articles

  validates :name, presence: true, uniqueness: { scope: :user_id }

  def to_param
    permalink
  end

  private

    def set_permalink
      self.permalink = name.parameterize
    end

    def destroy_articles
      self.articles.destroy_all
    end

end
