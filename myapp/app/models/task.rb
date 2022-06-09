class Task < ApplicationRecord
  has_rich_text :content
  validates :title, presence: true, length: { maximum: 50 }
  validates :due_date, presence: true

  # ステータス表記（0: 未着手, 1: 進行中, 2: 完了）
  enum status: { not_started: 0, in_progress: 1, completed: 2 }

  belongs_to :user
  has_many :task_labels
  has_many :labels, through: :task_labels
end
