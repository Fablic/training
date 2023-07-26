class Task < ApplicationRecord

  STATUSES = ["Not Started", "In Progress", "Completed"].freeze
  belongs_to :user
  belongs_to :user, :column :assigned_user_id

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :priority, presence: true,
end
