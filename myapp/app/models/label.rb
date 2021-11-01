class Label < ApplicationRecord
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels, dependent: :nullify
  validates :label, presence: true, length: { minimum: 2, maximum: 20 }
end
