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

  scope :search_by_name, -> (name) { where('name LIKE?', "%#{Task.sanitize_sql_like(name)}%") if name.present? }
  scope :search_by_status, -> (status) { where(status: status) if status.present? }
  scope :sort_by_column, -> (sort_column, sort_direction) { order("#{sort_column} #{sort_direction}") }
end
