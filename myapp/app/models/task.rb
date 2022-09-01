# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true
  validates :body,  presence: true
  validates :finish_at,  presence: true

  scope :desc, -> { order(created_at: :desc) }
  scope :finish_de, -> { order(finish_at: :desc) }
  scope :asc, -> { order(created_at: :asc) }
  scope :finish_a, -> { order(finish_at: :asc) }
end
