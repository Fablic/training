# frozen_string_literal: true

class Label < ApplicationRecord
  has_many :task_labels, dependent: false
  has_many :tasks, -> { distinct }, through: :task_labels
  validates :value, presence: true, length: { maximum: 255 }

  def cleanup
    self.destroy if tasks.count.zero?
  end
end
