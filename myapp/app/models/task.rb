class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :deadline, presence: true

  scope :deadline_order, -> (v){ order(deadline: v) }
end
