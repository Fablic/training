class Task < ApplicationRecord
  enum status: { waiting: 1, work_in_progress: 2, completed: 3 }

  validates :title, presence: true
  validates :description, presence: true

  scope :sort_tasks, ->(request_sort) do
    if request_sort&.has_key?(:created_at) || request_sort&.has_key?(:due_date)
      order(request_sort)
    else
      order(:created_at)
    end
  end
  scope :title_search, -> (title) do
    title.blank? ? all : where("title LIKE ?", title)
  end
  scope :status_search, -> (statuses) do
    status_ids = statuses.blank? ? nil : statuses&.reject(&:blank?)
    return all if status_ids.blank?

    where(status: statuses)
  end
end
