# Taskモデルは、タスクのタイトルと詳細を管理します。
# タイトルは必須であり、空であってはなりません。
class Task < ApplicationRecord
  belongs_to :user, optional: true
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  enum status: { not_started: 0, in_progress: 1, completed: 2 }, _default: :not_started
  enum priority: { high: 0, middle: 1, low: 2 }, _default: :middle

  validates :title, presence: true, length: { maximum: 100 }
  validates :status, presence: true
  validates :priority, presence: true
  validates :details, length: { maximum: 1000 }

  scope :default_order, -> { order(created_at: :desc) }
  scope :search_title, ->(title) { where('title LIKE ?', "%#{sanitize_sql_like(title)}%") if title.present? }
  scope :search_status, ->(status) { where(status:) if status.present? }
  scope :search_label, ->(label_id) { joins(:labels).where(labels: { id: label_id }) if label_id.present? }
end
