# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: false
  has_many :labels, -> { distinct }, through: :task_labels
  enum status: { open: 0, in_progress: 1, close: 2 }
  validates :name, presence: true, length: { maximum: 255 }
end
