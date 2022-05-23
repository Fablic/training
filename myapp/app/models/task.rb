class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :due_date, presence: true
  validates :status, presence: true, inclusion: { in: [0, 1, 2] }

  # ステータス表記（0: 未着手, 1: 進行中, 2: 完了）
  enum status: { not_started: 0, in_progress: 1, completed: 2 }
end
