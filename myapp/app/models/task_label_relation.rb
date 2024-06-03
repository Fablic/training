class TaskLabelRelation < ApplicationRecord
  belongs_to :task
  belongs_to :label
end
