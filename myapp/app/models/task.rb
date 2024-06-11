# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50, too_long: :title_too_long }
  validates :description, length: { maximum: 500, too_long: :desc_too_long }, allow_blank: true
  validates :deadline, presence: true
end
