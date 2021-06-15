class Task < ApplicationRecord
  enum status: { todo: 0, doing: 1, done: 2 }

  validates :name, presence: true, length: { maximum: 15 }
  validates :description, length: { maximum: 50 }
end
