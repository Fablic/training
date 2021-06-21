# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 5000 }
  enum task_status: { todo: 0, doing: 1, done: 2 }
end
