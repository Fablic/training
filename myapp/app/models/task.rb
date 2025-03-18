class Task < ApplicationRecord
  enum priority: { low: 0, medium: 1, high: 2 }
  enum status:   { "to do": 0, "in progress": 1, "done": 2 }

  validates :name, presence: true
  validates :priority, presence: true
  validates :status, presence: true
  validates :deadline, presence: true
end
