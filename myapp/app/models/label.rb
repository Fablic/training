class Label < ApplicationRecord
  has_many :task_label_relations, dependent: :destroy
  has_many :tasks, through: :task_label_relations
end
