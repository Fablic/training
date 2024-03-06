class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy
  validates :username, presence: true,  uniqueness: true, length: { maximum: 255 }
  validates :password_digest, presence: true, length: { maximum: 255 }
end
