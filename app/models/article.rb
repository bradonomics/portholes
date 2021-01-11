class Article < ApplicationRecord

  before_save :set_permalink

  belongs_to :user
  belongs_to :folder

  validates :title, presence: true
  validates :link, presence: true, uniqueness: { scope: :user_id }

  def to_param
    permalink
  end

  private

    def set_permalink
      self.permalink = title.parameterize
    end
    # TODO: make this the link path?

end
