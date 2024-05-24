require 'time'

class Task < ApplicationRecord
  validates :title, :description, presence: { message: 'must not be blank!' }
  validates :title, length: { in: 5..30, too_short: 'please input more than %{count} characters', too_long: '%{count} characters is the maximum allowed' }
  validates :description, length: { in: 10..300, too_short: 'please input more than %{count} characters', too_long: '%{count} characters is the maximum allowed' }
  validates :due, presence: { message: 'must be specified!' }

  validate :due_cannot_be_earlier_than_now_on_create, on: :create
  validate :due_cannot_be_changed_to_be_earlier_than_now_on_update, on: :update, if: :due_changed?

  def due_cannot_be_earlier_than_now_on_create
    if due.present? && due < Time.zone.now.beginning_of_minute
      errors.add(:due, "can't be earlier than now!")
    end
  end

  def due_cannot_be_changed_to_be_earlier_than_now_on_update
    if due.present? && due < Time.zone.now.beginning_of_minute
      errors.add(:due, "can't be earlier than now if you want to change!")
    end
  end
end
