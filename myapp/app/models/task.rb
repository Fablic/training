# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user, optional: false
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 30000 }
end
