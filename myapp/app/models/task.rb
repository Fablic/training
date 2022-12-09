# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 40 }
  validates :description, length: { maximum: 500 }

  def self.search(conditions)
    order("#{conditions['sort_column']} #{conditions['sort_direction']}")
  end
end
