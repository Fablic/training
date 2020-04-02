class Label < ApplicationRecord
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels

  NAME_MAX_LENGTH = 16

  validates :name,
    length: { maximum: NAME_MAX_LENGTH }
end
