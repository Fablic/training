class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  enum role: { normal: 0, admin: 1 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 },
                    format: { with: User::VALID_EMAIL_REGEX }
  has_secure_password

  def self.count_admin_user
    admin.count
  end
end
