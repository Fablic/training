class User < ApplicationRecord
  has_secure_password
  validates :username, uniqueness: { case_sensitive: true }, format: { with: /\A[^\s]*\z/ }, length: { in: 3..20 }
  validates :password, presence: true, confirmation: true, format: { with: /\A[^\s]*\z/ }, length: { in: 5..15 }, if: :password_exists?

  has_many :tasks, dependent: :destroy

  def self.with_tasks_count
    left_joins(:tasks).select('users.id, users.username, users.admin, COUNT(tasks.id) as tasks_count').group('users.id')
  end

  private 

  def password_exists?
    password.present? || password_confirmation.present?
  end
end
