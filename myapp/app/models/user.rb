# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :task, dependent: :nullify
  before_save { self.email = email.downcase }
  enum roles: { Normal: 0, Admin: 1 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true, length: { minimum: 6 }
  validates :name, presence: true
end
