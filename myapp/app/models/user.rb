class User < ApplicationRecord # rubocop:disable Style/Documentation
  has_many :tasks, dependent: :nullify

  enum role: %i[member admin], _default: 0

  validates :username, presence: true, uniqueness: true, length: { maximum: 25 }
  validates :password_digest, presence: true, length: { minimum: 5 }
end
