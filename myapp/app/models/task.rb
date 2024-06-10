# Taskモデルは、タスクのタイトルと詳細を管理します。
# タイトルは必須であり、空であってはなりません。
class Task < ApplicationRecord
  enum status: { not_started: 0, in_progress: 1, completed: 2 }, _default: :not_started
  enum priority: { high: 0, middle: 1, low: 2 }, _default: :middle

  validates :title, presence: true, length: { maximum: 100 }
  validates :status, presence: true
  validates :priority, presence: true
  validates :details, length: { maximum: 1000 }

  scope :default_order, -> { order(created_at: :desc) }
  scope :search_title, ->(title) { where('title LIKE ?', "%#{sanitize_sql_like(title)}%") if title.present? }
  scope :search_status, ->(status) { where(status:) if status.present? }
end
