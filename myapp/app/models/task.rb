# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title,
            length: { in: 1..100 }
  validates :description,
            length: { maximum: 1000 }

  attribute :status, ActiveRecord::Type::Integer.new
  enum status: { waiting: 0, working: 1, completed: 2 }
  validates :status,
            inclusion: { in: Task.statuses.keys }
end
