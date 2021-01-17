class User < ApplicationRecord
  before_create { generate_token(:hello_token) }

  has_many :folders, dependent: :destroy
  has_many :articles, through: :folders, dependent: :destroy

  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable, :lockable, :registerable, :recoverable, :rememberable, :validatable

  scope :not_admins, -> { by_name.where(admin: false) }

  def generate_token(column)
    begin
      self[column] = SecureRandom.alphanumeric(6)
    end while User.exists?(column => self[column])
  end

end
