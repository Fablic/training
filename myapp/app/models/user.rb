class User < ApplicationRecord
  validates :username, length: { in: 3..20, message: 'should be between 3 and 20 chars!' }
  validates :password, presence: true, confirmation: true

  has_many :tasks, dependent: :destroy
end
