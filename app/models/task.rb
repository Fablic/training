class Task < ApplicationRecord

  enum status: {
    todo: 0,
    in_progress: 1,
    done: 2
  }, _prefix: true

  enum priority: {
    low: 0,
    medium: 1,
    high: 2
  }, _prefix: true

  validates :name, presence: true
  validates :name, length: { maximum: 255 }
  validates :priority, inclusion: { in: priorities.keys }
end
