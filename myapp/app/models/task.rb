# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50, too_long: :title_too_long }
  validates :description, length: { maximum: 500, too_long: :desc_too_long }, allow_blank: true
  validates :deadline, presence: true
  validate :deadline_cannot_be_in_the_past

  private

  def deadline_cannot_be_in_the_past
    if deadline.present? && deadline < Time.now
      errors.add(:deadline, :past_deadline)
    end
  end
end

