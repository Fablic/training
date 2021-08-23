# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :password

  before_create :set_salt_and_password
  before_update :set_password_hash

  def validate_password(src)
    password_hash == strech_password(src)
  end

  private

  def strech_password(src)
    2000.times { src = OpenSSL::Digest.hexdigest('SHA256', "#{src}#{salt}") }
    src
  end

  def set_salt_and_password
    self.salt = SecureRandom.hex
    set_password_hash
  end

  def set_password_hash
    self.password_hash = strech_password(@password)
  end
end
