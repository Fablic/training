class Task < ApplicationRecord
  belongs_to :user, optional: true

  validates :title, presence: true
  validates :content, presence: true

  # 進捗ステータス（0=未着手 / 1=進行中 / 2=完了）
  enum status: { not_started: 0, in_progress: 1, completed: 2 }
end
