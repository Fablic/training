# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  enum status: { not_started: 0, in_progress: 1, done: 2 }

  belongs_to :user
end
