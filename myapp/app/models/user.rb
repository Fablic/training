# frozen_string_literal: true

# some comments for user model
class User < ApplicationRecord
  has_secure_password

  enum role: {
    admin: 0,
    normal: 1,
  }

  has_many :tasks, dependent: :destroy
  validates :name, presence: true, length: { maximum: 255 }
  validates :password, presence: true, length: { maximum: 255 }, on: :create
  validates :description, length: { maximum: 1000 }
  validates :role, presence: true
end
