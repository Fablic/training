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
end
