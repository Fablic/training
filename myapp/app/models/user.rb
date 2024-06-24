class User < ApplicationRecord # rubocop:disable Style/Documentation
  has_secure_password

  has_many :tasks, dependent: :nullify

  enum role: %i[member admin], _default: :member

  validates :username, presence: true, uniqueness: true, length: { maximum: 25 }
  validates :password, presence: true, length: { minimum: 5 }
end
