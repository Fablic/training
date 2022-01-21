# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  enum role: { admin: 0, user: 1 }
  attribute :role, :integer, default: 0

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :role, inclusion: { in: roles }
end
