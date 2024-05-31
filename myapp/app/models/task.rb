class Task < ApplicationRecord
  belongs_to :user
  has_many :task_label_relations
  has_many :labels, through: :task_label_relations
end
