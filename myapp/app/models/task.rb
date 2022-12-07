# frozen_string_literal: true

class Task < ApplicationRecord
  scope :latest, -> { order(created_at: :desc) }
end
