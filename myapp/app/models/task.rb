# frozen_string_literal: true

# some comments for task model
class Task < ApplicationRecord
  enum priority_type: {
    Low: 0,
    Medium: 1,
    High: 2,
  }
  enum status_type: {
    Todo: 0,
    Doing: 1,
    Done: 2,
  }

  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }
  validates :priority, presence: true, numericality: { only_integer: true }
  validates :status, presence: true, numericality: { only_integer: true }
end
