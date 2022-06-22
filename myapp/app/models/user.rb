class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true
end
