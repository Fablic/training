# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true
  validates :body,  presence: true
  validates :finish_at, presence: true

  scope :desc, -> { order(created_at: :desc) }
  scope :finish_desc, -> { order(finish_at: :desc) }
  scope :asc, -> { order(created_at: :asc) }
  scope :finish_asc, -> { order(finish_at: :asc) }

  enum status: {
    untouched: 0,
    in_progress: 1,
    completion: 2,
  }
end
