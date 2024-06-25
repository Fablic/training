# frozen_string_literal: true

class User < ApplicationRecord
  require 'bcrypt'
  attr_accessor :password, :password_confirmation

  has_many :tasks, dependent: :nullify

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true, length: { minimum: 1 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, if: :password_required?

  before_save :encrypt_password
  before_save { email.downcase! }

  def encrypt_password
    return unless password.present?

    self.password_digest = BCrypt::Password.create(password)
  end

  def authenticate(submitted_password)
    BCrypt::Password.new(password_digest) == submitted_password
  end

  def password_required?
    password_digest.blank? || password.present?
  end

  def admin?
    admin
  end
end
