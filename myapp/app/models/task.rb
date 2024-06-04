# Taskモデルは、タスクのタイトルと詳細を管理します。
# タイトルは必須であり、空であってはなりません。
class Task < ApplicationRecord
  enum status: { not_started: 0, in_progress: 1, completed: 2 }
  enum priority: { high: 0, middle: 1, low: 2 }

  validates :title, presence: true, length: { maximum: 255 }
  validates :status, presence: true
  validates :priority, presence: true
  validates :details, length: { maximum: 30_000 }

  after_initialize :set_defaults, unless: :persisted?

  private

  def set_defaults
    self.status ||= :not_started
    self.priority ||= :middle
  end
end
