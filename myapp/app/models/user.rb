class User < ApplicationRecord # rubocop:disable Style/Documentation
  has_many :tasks, dependent: :nullify

  enum role: %i[member admin], _default: 1

  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
end
