# frozen_string_literal: true

class TaskLabelRelation < ApplicationRecord # rubocop:disable Style/Documentation
  belongs_to :task
  belongs_to :label
end
