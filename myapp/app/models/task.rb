# frozen_string_literal: true

class Task < ApplicationRecord
  validates :task_name, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }
  validate :integrative_check?

  def integrative_check?
    return if starts_on.blank? || ends_on.blank?

    errors.add(:ends_on, 'は開始日より後の日程に設定してください。') if starts_on > ends_on
  end
end
