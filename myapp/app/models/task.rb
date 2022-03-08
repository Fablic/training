# frozen_string_literal: true

class Task < ApplicationRecord
  validates :task_name, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }
  validate :ends_on_must_be_after_starts_on

  private

  def ends_on_must_be_after_starts_on
    return if starts_on.blank? || ends_on.blank?

    errors.add(:ends_on, :must_be_after_starts_on) if starts_on > ends_on
  end
end
