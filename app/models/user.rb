class User < ApplicationRecord

  has_many :folders, dependent: :destroy
  has_many :articles, through: :folders, dependent: :destroy

  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable, :lockable, :registerable, :recoverable, :rememberable, :validatable

  scope :not_admins, -> { by_name.where(admin: false) }

end
