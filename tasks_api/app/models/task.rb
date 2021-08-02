# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: { open: 0, in_progress: 1, close: 2 }
  validates :name, presence: true, length: { maximum: 255 }
end
