class User < ApplicationRecord
  has_secure_password
  validates :username, length: { in: 3..20, message: 'should be between 3 and 20 chars!' }
  validates :password, presence: true, confirmation: true

  has_many :tasks, dependent: :destroy
  validates :username, format: { with: /\A[^\s]*\z/, message: 'should not contain space!' }
  validates :username, uniqueness: { message: 'duplicated. Please use another username!' }
end
