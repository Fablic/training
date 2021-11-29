# frozen_string_literal: true

class TaskLabel < ApplicationRecord
  belongs_to :label
  belongs_to :task
end
