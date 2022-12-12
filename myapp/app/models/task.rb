# frozen_string_literal: true

class Task < ApplicationRecord
  SORT_COLUMN_ALLOWED = %w[created_at end_date].freeze

  validates :title, presence: true, length: { maximum: 40 }
  validates :description, length: { maximum: 500 }

  scope :sort_tasks, lambda { |sort_column, sort_direction|
    order("#{sort_column} #{sort_direction}") if sort_column.in? SORT_COLUMN_ALLOWED
  }
end
