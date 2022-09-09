class User < ApplicationRecord
  has_many :tasks, dependent: :delete_all
  validates :personal_id, presence: true
  validates :password, presence: true
  has_secure_password
end
