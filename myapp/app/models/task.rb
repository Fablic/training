class Task < ApplicationRecord
  STATUSES = ["Not Started", "In Progress", "Done"].freeze
  
  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :priority, presence: true, numericality: { only_integer: true }

  belongs_to :user
  has_many :task_labels
  has_many :labels, through: :task_labels
end
