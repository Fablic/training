class User < ApplicationRecord
  has_secure_password
  enum role: { admin: 0, user: 1 }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: roles }
end
