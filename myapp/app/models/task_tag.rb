class TaskTag < ApplicationRecord
  belongs_to :task
  belongs_to :tag
end
