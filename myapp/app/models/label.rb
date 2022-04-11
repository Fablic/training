class Label < ApplicationRecord
  validates :name, presence: true

  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels
end
