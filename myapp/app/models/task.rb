class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :deadline, presence: true

  enum status: { not_started: 0, start: 1, completed: 2 }

  scope :where_title, -> (title) { where('title like ?', "%#{title}%") if title.present? }
  scope :where_status, -> (status) { where(status: status) if status.present? }

  scope :deadline_order, -> (v){ order(deadline: v) }
end
