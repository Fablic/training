class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 256 }
  validates :description, presence: true, length: { maximum: 1024 }
end
