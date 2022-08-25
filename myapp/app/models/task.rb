class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { maximum: 10 }
  validates :description, presence: true
  validates :description, length: { maximum: 50 }
end
