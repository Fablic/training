# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :name, presence: true, length: { maximum: 30, allow_blank: true }, uniqueness: true # TODO: Rails/UniqueValidationWithoutIndex step11で直す
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } # TODO: Rails/UniqueValidationWithoutIndex step11で直す
  validates :password_digest, presence: true, length: { minimum: 8 }, allow_nil: true
end
