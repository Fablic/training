class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :deadline, presence: true

  scope :deadleine_asc, -> { order(deadline: :asc) }
  scope :deadline_desc, -> { order(deadline: :desc) }
end
