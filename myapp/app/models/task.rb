# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true
  validates :body,  presence: true
  scope :desc, -> { order(created_at: :desc) }
  scope :asc, -> { order(created_at: :asc) }
end
