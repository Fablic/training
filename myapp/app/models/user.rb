class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  validates :name, presence: true
  validates :personal_id, presence: true, uniqueness: { case_sensitive: true }
  validates :password, presence: true
  has_secure_password
end
