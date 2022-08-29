# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  def self.create_salt
    Digest::SHA256.hexdigest(SecureRandom.alphanumeric(5))
  end

  def self.create_password(password, salt)
    "#{Digest::SHA256.hexdigest("#{password}#{ENV['PEPPER']}")}#{salt}"
  end
end
