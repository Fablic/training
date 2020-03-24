class User < ApplicationRecord
  enum role: { general: 0, admin: 1 }

  has_many :tasks, dependent: :destroy

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    uniqueness: true,
    format: { with: VALID_EMAIL_REGEX }

  validates :first_name,
    presence: true,
    length: { maximum: 20 }

  validates :last_name,
    presence: true,
    length: { maximum: 20 }

  validates :role,
    presence: true

  def view_name
    last_name + ' ' + first_name
  end
end
