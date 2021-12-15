class Label < ApplicationRecord
    has_many :tasks, through: :task_labels
    has_many :task_labels
end
