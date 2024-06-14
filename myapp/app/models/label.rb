class Label < ApplicationRecord
  has_many :tasks_labels
  has_many :tasks, through: :tasks_labels
end
