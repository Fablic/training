class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 } 
  validates :description, length: { maximum: 30000 } 
end
