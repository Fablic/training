class User < ApplicationRecord
  has_many :tasks

  validates :email, presence: true, uniqueness: { case_sensitive: true }

  before_create :set_password_digest

  attr_accessor :password

  def authenticate(password)
    self.password_digest == User.create_hash(password, self.salt) ? true : false
  end

  def self.create_salt
    Digest::SHA256.hexdigest(SecureRandom.alphanumeric(5))
  end

  def self.create_hash(password, salt)
    "#{Digest::SHA256.hexdigest("#{password}")}#{salt}"
  end

  private

  def set_password_digest
    self.salt = User.create_salt
    self.password_digest = User.create_hash(self.password, self.salt)
  end
end
