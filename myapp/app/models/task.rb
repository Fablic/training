# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { minimum: 2, maximum: 32 }
  enum priority: { Low: 1, Normal: 2, High: 3 }
  enum status: { TODO: 1, IN_PROGRESS: 2, DONE: 3 }

  scope :sort_limit, -> { order(limit: 'ASC') }
end
