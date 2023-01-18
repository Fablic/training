# == Schema Information
#
# Table name: users
#
#  id              :integer          unsigned, not null, primary key
#  email           :string(255)      not null
#  is_admin        :boolean          default(FALSE), not null
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  tasks_count     :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: true }, format: {with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: 'is not a valid email format'}

  has_many :tasks, dependent: :delete_all

  has_many :editable_task_users
  has_many :editable_tasks, through: :editable_task_users, source: :task

  before_destroy :stop_destroy

  has_secure_password

  scope :admin, -> { where(is_admin: true) }

  def the_only_admin?
    return false unless is_admin
    return false if User.admin.limit(2).count == 2
    User.admin.first.id == id
  end

  def stop_destroy
    return unless the_only_admin?

    errors.add(:base, 'Cannot delete the last admin role')
    throw :abort
  end
end
