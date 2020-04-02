class TaskLabel < ApplicationRecord
  belongs_to :task
  belongs_to :label

  validates :task_id, presence: true
  validates :label_id, presence: true
end
