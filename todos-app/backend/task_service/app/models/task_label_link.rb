# frozen_string_literal: true

class TaskLabelLink < ApplicationRecord
  belongs_to :task
  belongs_to :label
end
