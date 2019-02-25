# frozen_string_literal: true

class Label < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
end
