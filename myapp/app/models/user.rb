class User < ApplicationRecord
  has_secure_password
  validates :username, length: { in: 3..20 }
  validates :password, presence: true, confirmation: true, format: { with: /\A[^\s]*\z/ }

  has_many :tasks, dependent: :destroy
  validates :username, format: { with: /\A[^\s]*\z/ }
end
