class Task < ApplicationRecord
    validates :title, presence: true
    validates :title, length: { maximum: 30 }
    validates :description, presence: true
    validates :description, length: { maximum: 100 }
end
