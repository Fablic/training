class User < ApplicationRecord
  before_create :encrypt_password
  has_many :tasks

  require 'securerandom'

  def encrypt_password
    salt_digest = Digest::MD5.hexdigest(User.generate_salt)
    self.salt = salt_digest
    self.password = User.password_digest(password, salt_digest)
  end

  def self.password_digest(password, salt_digest)
    pass_digest = Digest::MD5.hexdigest(password)
    Digest::MD5.hexdigest(pass_digest + salt_digest)
  end

  def self.generate_salt
     SecureRandom.hex(10)
  end
end
