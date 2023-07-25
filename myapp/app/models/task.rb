# frozen_string_literal: true

# some comments for task model
class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  enum priority: {
    low: 0,
    medium: 1,
    high: 2,
  }
  enum status: {
    todo: 0,
    doing: 1,
    done: 2,
  }

  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }
  validates :priority, presence: true
  validates :status, presence: true

  scope :search_by_name, -> (name) { where('name LIKE?', "%#{Task.sanitize_sql_like(name)}%") if name.present? }
  scope :search_by_label_name, lambda { |label_name|
    left_joins(:task_labels, :labels).where('labels.name LIKE?', "%#{Label.sanitize_sql_like(label_name)}%") if label_name.present?
  }
  scope :search_by_status, -> (status) { where(status: status) if status.present? }
  scope :get_own_tasks, -> (user_id) { where(user_id: user_id) if user_id.present? }
  scope :get_task_labels, -> (task_id) { select('labels.name').left_joins(:task_labels, :labels).where(id: task_id) if task_id.present? }
  scope :sort_by_column, lambda { |sort_column, sort_direction|
    sc = Task.column_names.include?(sort_column) ? sort_column : 'created_at'
    sd = %w[ASC DESC].include?(sort_direction) ? sort_direction : 'ASC'
    order("#{sc} #{sd}")
  }
end
