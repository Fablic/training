# frozen_string_literal: true

class Task < ApplicationRecord
  SORT_COLUMN_ALLOWED = %w[created_at end_date].freeze

  validates :title, presence: true, length: { maximum: 40 }
  validates :description, length: { maximum: 500 }

  scope :sort_tasks, lambda { |sort_column, sort_direction|
    order("#{sort_column} #{sort_direction}") if sort_column.in? SORT_COLUMN_ALLOWED
  }

  def self.search(conditions)
    #検索
    tasks = Task.where('title LIKE?',"%#{conditions[:keyword]}%")
    if conditions[:status] =~ /^[0|1|2]$/
      tasks = tasks.where('status=?', conditions[:status]) 
    end

    #ソート
    tasks = tasks.sort_tasks(conditions['sort_column'], conditions['sort_direction'])

    tasks.present? ? tasks : {}
  end
end
