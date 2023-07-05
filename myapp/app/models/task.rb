# frozen_string_literal: true

# some comments for task model
class Task < ApplicationRecord
  enum priority: {
    low: 0,
    medium: 1,
    high: 2,
  }
  enum status: {
    todo: 0,
    doing: 1,
    done: 2,
  }

  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }
  validates :priority, presence: true
  validates :status, presence: true

  scope :search_by_name, -> (name) { where('name LIKE?', "%#{Task.sanitize_sql_like(name)}%") if name.present? }
  scope :search_by_status, -> (status) { where(status: status) if status.present? }
  scope :sort_by_column, -> (sort_column, sort_direction) { order("#{sort_column} #{sort_direction}") }
end
