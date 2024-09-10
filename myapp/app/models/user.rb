class User < ApplicationRecord
  has_many :tasks

  has_secure_password
  # 8~20, lowercase, uppercase, digit and special chars must be used at least once
  PASSWORD_FORMAT = /\A(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[-+_!@#$%^&*.,?]).{8,20}\z/

  validates :name, presence: true, length: { minimum: 5, maximum: 20 }, uniqueness: { case_sensitive: false }
  validates :password,
    format: {
      with: PASSWORD_FORMAT,
      message: :invalid_password,
      min: 8,
      max: 20
  }
end
