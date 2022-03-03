class Task < ApplicationRecord
  enum priority: { high: 1, middle: 2, low: 3 }
  enum status: { '未着手' => 1, '着手' => 2, '完了' => 3 }

  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :title, length: { in: 1..256 }
  validates :body, presence: true
  validates :deadline, presence: true
  validates :priority, presence: true, inclusion: { in: Task.priority.keys }
  validates :status, presence: true, inclusion: { in: Task.status.keys }

  validate :deadline_before_today

  private

  def deadline_before_today
    return if deadline.blank?
    errors.add(:deadline, "は今日以降を選択してください") if deadline < Date.today
  end
end
