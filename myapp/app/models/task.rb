# frozen_string_literal: true

class Task < ApplicationRecord
  enum statuses: { Open: 0, 'In Progress': 1, Done: 2 }
  enum priorities: { Low: 0, Medium: 1, High: 2 }

  validates :name, presence: true, length: { maximum: 30 }, allow_blank: false
  validates :desc, presence: true, length: { maximum: 100 }, allow_blank: false
  validates :status, presence: true
  validates :label, presence: true
  validates :priority, presence: true
  validates :due_date, presence: true

  def self.sort_tasks (request_sort)
    if request_sort&.has_key?(:created_at) || request_sort&.has_key?(:due_date)
      order(request_sort)
    else
      order(:created_at)
    end
  end
end
