class User < ApplicationRecord
  has_secure_password

  validates :email, presence:true, uniqueness: true
  validates :name, presence: true
  validates :password_digest, presence: true, length: { in: 6..20 }
end
