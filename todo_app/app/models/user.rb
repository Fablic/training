# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  enum role: { general: 1, admin: 2 }

  has_many :tasks, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  before_destroy :ensure_role_and_admin_user_count

  private

  def ensure_role_and_admin_user_count
    return if User.admin.count > 1 || self.general?

    errors.add(:role, :should_be_at_least_one_admin)
    throw :abort
  end
end
