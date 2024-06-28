# frozen_string_literal: true

class Task < ApplicationRecord # rubocop:disable Style/Documentation
  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: %w[open in_progress closed] }
  validates :priority, presence: true, inclusion: { in: %w[high medium low] }
  validates :due_date, presence: true

  belongs_to :user

  enum status: { open: 0, in_progress: 1, closed: 2 }
  enum priority: { low: 0, medium: 1, high: 2 }

  def self.search(query, status, user_id)
    tasks = all.includes(:user)
    tasks = tasks.where(user_id: user_id) unless user_id.nil?
    tasks = tasks.where('title LIKE ?', "%#{query}%") if query.present?
    tasks = tasks.where(status: status) if status.present?
    tasks
  end
end
