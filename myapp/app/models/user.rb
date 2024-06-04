class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  validates :username, format: { with: /\A[^\s]*\z/, message: 'should not contain space!' }
end
