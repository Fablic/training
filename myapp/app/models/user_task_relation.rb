# frozen_string_literal: true

class UserTaskRelation < ApplicationRecord
  belongs_to :user
  belongs_to :task
end
