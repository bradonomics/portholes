class User < ApplicationRecord
  before_create { generate_token(:hello_token) }

  has_many :folders, dependent: :destroy
  has_many :articles, through: :folders, dependent: :destroy

  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable, :lockable, :registerable, :recoverable, :rememberable, :validatable

  validate :password_complexity

  def password_complexity
    # Regexp from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    if password.length >= 15
      return if password =~ /^[\s\S]{15,128}$/
    else
      return if password =~ /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,128}$/
    end

    errors.add :password, 'Your password must be at least 15 characters OR at least 8 characters including at least one letter, one number, and one special character'
  end

  scope :not_admins, -> { by_name.where(admin: false) }

  def generate_token(column)
    begin
      self[column] = SecureRandom.alphanumeric(6)
    end while User.exists?(column => self[column])
  end

end
