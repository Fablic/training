# frozen_string_literal: true

class Label < ApplicationRecord
  has_many :tasks

  validates :name, presence: true, length: { maximum: 30 }
end
