# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title,
            length: { in: 1..100 }
  validates :description,
            length: { maximum: 1000 }
end
