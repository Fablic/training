class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 15 }
  validates :description, length: { maximum: 50 }
end
