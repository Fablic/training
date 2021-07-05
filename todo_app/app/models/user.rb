# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  enum role: { general: 1, admin: 2 }

  has_many :tasks, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  before_destroy :ensure_admin_user_count

  private

  def ensure_admin_user_count
    return unless User.admin.count <= 1

    errors.add(:role, :should_be_at_least_one_admin)
    throw :abort
  end
end
