class TaskLink < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :task, class_name: 'Task'
end
