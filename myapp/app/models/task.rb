class Task < ApplicationRecord
  STATUSES = ["Not Started", "In Progress", "Done"].freeze
  
  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :priority, presence: true, numericality: { only_integer: true }

  belongs_to :user
  has_many :task_labels
  has_many :labels, through: :task_labels

  scope :search_by_name_and_status, -> (name, status) { 
    task = Task.all
    task = task.where("name LIKE ?", "%#{name}%") if name.present?
    task = task.where(status: status) if status.present?
    task
  }
end
