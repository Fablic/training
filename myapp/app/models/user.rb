# frozen_string_literal: true

require 'bcrypt'

class User < ApplicationRecord
  attr_accessor :password

  has_many :tasks
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  before_save :encrypt_password

  def encrypt_password
    return unless password.present?

    self.password_digest = BCrypt::Password.create(password)
  end

  def authenticate(submitted_password)
    BCrypt::Password.new(password_digest) == submitted_password
  end
end
