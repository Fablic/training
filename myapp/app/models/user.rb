class User < ApplicationRecord
  has_secure_password

  has_many :task
  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password_digest, presence: true, length: { minimum: 6 }
  validates :name, presence: true
end
