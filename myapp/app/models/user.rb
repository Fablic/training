class User < ApplicationRecord
  has_many :tasks

  has_secure_password

  validates :name, presence: true, length: { minimum: 5, maximum: 20 }, uniqueness: { case_sensitive: false }
end
