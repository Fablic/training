# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password

  enum role: { normal: 0, admin: 1 }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true

  scope :admin_users, -> { where(role: :admin) }

  def last_admin?
    return true if admin? && User.admin_users.count < 2

    false
  end
end
