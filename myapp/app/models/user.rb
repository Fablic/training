class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }, format: { with: User::VALID_EMAIL_REGEX }

  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }

  enum role: { general: false, admin: true }
end
