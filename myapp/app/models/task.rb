# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 40 }
  validates :description, length: { maximum: 500 }

  scope :latest, -> { order(created_at: :desc) }
  scope :expiring, -> { order(end_date: :asc) }

  def self.search(conditions)
    tasks = Task.where('title LIKE?',"%#{conditions[:keyword]}%")
    tasks = tasks.where('status=?', conditions[:status].to_i) if conditions[:status].present?

    tasks = tasks.order("#{conditions['sort_column']} #{conditions['sort_direction']}")

    tasks.present? ? tasks : {}
  end
end
