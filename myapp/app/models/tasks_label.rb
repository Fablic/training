# frozen_string_literal: true

class TasksLabel < ApplicationRecord # rubocop:todo Style/Documentation
  belongs_to :task
  belongs_to :label
end
