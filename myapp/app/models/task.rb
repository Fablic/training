class Task < ApplicationRecord
  validates :created_by, { presence: true }
  validates :name, { presence: true, length: { maximum: 75 } }
  validates :description, { length: { maximum: 1000 } }
  validates :finished_at, { presence: true }
end
