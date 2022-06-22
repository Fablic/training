# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  enum priority: {Low: 1, Normal: 2, High: 3}
  enum status: {TODO: 1, IN_PROGRESS: 2, DONE: 3}
end
