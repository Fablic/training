class User < ApplicationRecord
  has_secure_password
  validates :username, uniqueness: { case_sensitive: true }, format: { with: /\A[^\s]*\z/ }, length: { in: 3..20 }
  validates :password, presence: true, confirmation: true, format: { with: /\A[^\s]*\z/ }, length: { in: 5..15 }

  has_many :tasks, dependent: :destroy
end
