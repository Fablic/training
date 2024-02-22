class Task < ApplicationRecord
    STATUSES = ["Not Started", "In Progress", "Done"].freeze
    PRIORITY = ["High" , "Medium", "Low"].freeze
    validates :name, presence: true
    validates :status, presence: true, inclusion: { in: STATUSES }
    validates :priority, presence: true, inclusion: { in: PRIORITY }
end
