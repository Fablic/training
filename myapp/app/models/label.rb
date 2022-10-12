# frozen_string_literal: true

class Label < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
end
