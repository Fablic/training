# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: {
    todo: 0,
    in_progress: 1,
    done: 2,
  }

  enum priority: {
    low: 25,
    middle: 50,
    high: 75,
  }

  validates :title, {
    presence: true,
    length: {
      maximum: 255,
    },
  }
  validates :description, {
    allow_blank: true,
    length: {
      maximum: 768,
    },
  }
  validates :status, {
    allow_blank: true,
    inclusion: { in: self.statuses.keys },
  }
  validates :priority, {
    allow_blank: true,
    inclusion: { in: self.priorities.keys },
  }
end
