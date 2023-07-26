class Task < ApplicationRecord

  STATUSES = ["Not Started", "In Progress", "Completed"].freeze

  belongs_to :user
  belongs_to :user, :column :assigned_user_id

  has_many :labels, through: :tasks_labels

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :priority, presence: true,
end
