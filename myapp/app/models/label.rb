class Label < ApplicationRecord

    has_many :tasks, through: :tasks_labels

    validates :name, presence: true

end
