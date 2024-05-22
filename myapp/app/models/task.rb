require 'time'

class Task < ApplicationRecord
  validates :title, :description, presence: { message: 'must not be blank!' }
  validates :due, presence: { message: 'must be specified!' }

  validate :due_cannot_be_in_the_past

  def due_cannot_be_in_the_past
    if due.present? && due < Time.now
      errors.add(:due, "can't be in the past")
    end
  end
end
