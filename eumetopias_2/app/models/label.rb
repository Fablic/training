class Label < ApplicationRecord
  has_many :task_labelings, dependent: :destroy
  has_many :tasks, through: :tasak_labelings
end
