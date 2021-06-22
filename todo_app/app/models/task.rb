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
  scope :search, -> (title, statuses) do
    status_ids = statuses&.reject(&:blank?)
    return all if title.blank? && status_ids.blank?

    where_titles = title.blank? ? all : where("title LIKE ?", title)
    where_titles.where(status: (status_ids.blank? ? Task.statuses.values : statuses))
  end
end
