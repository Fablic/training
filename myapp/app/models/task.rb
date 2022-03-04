class Task < ApplicationRecord
    validates :task_name, presence: true
    validates :description, presence: true
end
