# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  enum priority: [low: 1, normal: 2, high: 3]
  enum status: [todo: 1, in_progress: 2, done: 3]
end
