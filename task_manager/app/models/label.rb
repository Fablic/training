class Label < ApplicationRecord
  has_many :task_labels
  has_many :tasks, through: :task_labels

  validates :name, presence: true, uniqueness: true
end
