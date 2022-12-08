# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 40 }
  validates :description, length: { maximum: 500 }

  scope :latest, -> { order(created_at: :desc) }
  scope :expiring, -> { order(end_date: :asc) }
end
