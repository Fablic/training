VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

class User < ApplicationRecord
  has_secure_password
  include IdGenerator
  validates :username,
    presence: true,
    length: { maximum: 20 },
    uniqueness: { case_sensitive: false }

  validates :email,
    presence: true,
    length: { maximum: 254 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  validates :icon,
    length: { maximum: 2000 }
  enum role: [:normal, :admin]
  has_many :tasks
end
