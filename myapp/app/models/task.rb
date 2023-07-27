class Task < ApplicationRecord
  STATUSES = ["Not Started", "In Progress", "Done"].freeze
  belongs_to :user
  has_many :task_labels
  has_many :labels, through: :task_labels

  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :priority, presence: true, numericality: { only_integer: true }
end
