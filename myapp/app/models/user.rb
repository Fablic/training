class User < ApplicationRecord
  has_many :tasks

  acts_as_paranoid

  USERNAME_LENGTH_MIN = 5
  USERNAME_LENGTH_MAX = 20

  has_secure_password
  # 8~20, lowercase, uppercase, digit and special char must be used at least once
  PASSWORD_LENGTH_MIN = 8
  PASSWORD_LENGTH_MAX = 20
  PASSWORD_FORMAT = /\A(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[-+_!@#$%^&*.,?]).{#{PASSWORD_LENGTH_MIN},#{PASSWORD_LENGTH_MAX}}\z/

  enum :role, { role_normal: 0, role_admin: 1, role_moderator: 2 }, validate: true

  validates :name, presence: true, length: { minimum: USERNAME_LENGTH_MIN, maximum: USERNAME_LENGTH_MAX }, uniqueness: { case_sensitive: false }
  validates :password,
            presence: true,
            length: { minimum: PASSWORD_LENGTH_MIN, maximum: PASSWORD_LENGTH_MAX },
            format: {
              with: PASSWORD_FORMAT,
              message: :invalid_password,
          }
end
