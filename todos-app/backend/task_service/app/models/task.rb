class Task < ApplicationRecord
  enum status: {not_started: 0, in_progress: 1, done: 2}
  enum priority: {high: 0, medium: 1, low: 2}

  validates :user_id, presence: true
  validates :title, length: {maximum: 20}, presence: true
  validates :description, length: {maximum: 200}, allow_nil: true
  validates :status, inclusion: {in: statuses}
  validates :priority, inclusion: {in: priorities}
  validates_datetime :due_datetime, allow_nil: true
end
