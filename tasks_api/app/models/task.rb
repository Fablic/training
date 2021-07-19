# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true
end
