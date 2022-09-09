# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: true }

  before_create :set_password_digest

  attr_accessor :password

  def authenticate(password)
    self.password_digest == User.hash(password, self.salt) ? true : false
  end

  def self.create_salt
    Digest::SHA256.hexdigest(SecureRandom.alphanumeric(5))
  end

  def self.hash(password, salt)
    "#{Digest::SHA256.hexdigest("#{password}#{ENV['PEPPER']}")}#{salt}"
  end

  def self.create_login_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt_login_token(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  private

  def set_password_digest
    self.salt = User.create_salt
    self.password_digest = User.hash(self.password, self.salt)
  end
end
