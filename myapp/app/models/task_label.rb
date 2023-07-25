# frozen_string_literal: true

# some comments for task_label model
class TaskLabel < ApplicationRecord
  belongs_to :task
  belongs_to :label
end
