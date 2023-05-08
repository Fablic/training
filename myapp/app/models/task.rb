class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :deadline, presence: true
end
