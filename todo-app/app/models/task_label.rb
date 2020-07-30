# frozen_string_literal: true

class TaskLabel < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }
  belongs_to :task
end
