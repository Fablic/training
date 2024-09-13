class User < ApplicationRecord
  has_many :tasks

  acts_as_paranoid

  USER_MIN = 5
  USER_MAX = 20

  has_secure_password
  # 8~20, lowercase, uppercase, digit and special char must be used at least once
  PASSWORD_MIN = 8
  PASSWORD_MAX = 20
  PASSWORD_FORMAT = /\A(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[-+_!@#$%^&*.,?]).{#{PASSWORD_MIN},#{PASSWORD_MAX}}\z/

  enum :role, { role_normal: 0, role_admin: 1, role_moderator: 2 }, validate: true

  validates :name, presence: true, length: { minimum: USER_MIN, maximum: USER_MAX }, uniqueness: { case_sensitive: false }
  validates :password,
            presence: true,
            length: { minimum: PASSWORD_MIN, maximum: PASSWORD_MAX },
            format: {
              with: PASSWORD_FORMAT,
              message: :invalid_password,
          }
end
