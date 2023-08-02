class Label < ApplicationRecord
    validates :name, presence: true

    has_many :task_labels
    has_many :tasks, through: :task_labels
end
