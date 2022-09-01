class Task < ApplicationRecord
    validates :title, presence: true, length: { maximum: 30 }
    validates :description, presence: true, length: { maximum: 100 }
end
