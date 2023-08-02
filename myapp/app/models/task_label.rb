class TaskLabel < ApplicationRecord
  validates :task_id, presence: true
  validates :label_id, presence: true
  
  belongs_to :task
  belongs_to :label
end
