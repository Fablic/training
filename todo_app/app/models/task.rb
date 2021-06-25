class Task < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true

  scope :sort_tasks, ->(request_sort) do
    if request_sort&.has_key?(:created_at) || request_sort&.has_key?(:due_date)
      order(request_sort)
    else
      order(:created_at)
    end
  end
end
