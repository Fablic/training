class Label < ApplicationRecord
  has_many :tasks_labels, dependent: :delete_all
  has_many :tasks, through: :tasks_labels
end
