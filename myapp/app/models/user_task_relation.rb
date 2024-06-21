# frozen_string_literal: true

class UserTaskRelation < ApplicationRecord # rubocop:disable Style/Documentation
  belongs_to :user
  belongs_to :task
end
