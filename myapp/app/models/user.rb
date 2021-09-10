class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  has_secure_password validations: true

  validates :name, presence: true, uniqueness: true
end
