class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :tasks, dependent: :destroy
  has_many :labels, dependent: :destroy
end
