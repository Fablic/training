# frozen_string_literal: true

class TaskLabel < ApplicationRecord
  belongs_to :task
  belongs_to :label
end
