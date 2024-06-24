# frozen_string_literal: true

class Task < ApplicationRecord # rubocop:disable Style/Documentation
  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: %w[open in_progress closed] }
  validates :priority, presence: true, inclusion: { in: %w[high medium low] }
  validates :due_date, presence: true

  belongs_to :user

  has_many :task_label_relations, dependent: :destroy
  has_many :labels, through: :task_label_relations

  enum status: { open: 0, in_progress: 1, closed: 2 }
  enum priority: { low: 0, medium: 1, high: 2 }

  def self.search(query, status)
    tasks = all
    tasks = tasks.where('title LIKE ?', "%#{query}%") if query.present?
    tasks = tasks.where(status: status) if status.present?
    tasks
  end

end

