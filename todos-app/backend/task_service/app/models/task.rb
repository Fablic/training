class Task < ApplicationRecord
  validates :user_id, presence: true
  validates :title, length: {maximum: 20}, presence: true
  validates :description, length: {maximum: 200}, allow_nil: true
  validates :status, inclusion: {in: [0, 1, 2]}, presence: true
  validates :priority, inclusion: {in: [0, 1, 2]}, presence: true
  validates_datetime :due_datetime, allow_nil: true
end
