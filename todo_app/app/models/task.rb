# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: { waiting: 1, work_in_progress: 2, completed: 3 }

  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true

  scope :sort_tasks, lambda { |request_sort|
    if request_sort&.key?(:created_at) || request_sort&.key?(:due_date)
      order(request_sort)
    else
      order(:created_at)
    end
  }
  scope :title_search, lambda { |title|
    title.blank? ? all : where('title LIKE ?', title)
  }
  scope :status_search, lambda { |statuses|
    statuses.presence&.reject(&:blank?).present? ? where(status: statuses) : all
  }
end
