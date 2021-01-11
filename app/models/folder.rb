class Folder < ApplicationRecord

  before_save :set_permalink

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

end
