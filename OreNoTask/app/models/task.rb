# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, { presence: true, length: { maximum: 50 } }
  validates :description, length: { maximum: 2000 }
  validates :start_at, presence: true, date: true
  validates :due_date_at, presence: true, date: true
  validate :start_end_check?

  def start_end_check?
    return if self.start_at.blank? || self.due_date_at.blank?

    errors.add(:due_date_at, I18n.t('dictionary.messages.invalid_date_diff')) unless
      self.start_at < self.due_date_at
  end

  def self.search(keyword, status)
    if status.empty?
      return where(["(name like? OR description like?) AND deleted =?", "%#{keyword}%", "%#{keyword}%", 0])
    else
      return where(["(name like? OR description like?) AND status =? AND deleted =?", "%#{keyword}%", "%#{keyword}%", "#{status}", 0])
    end
  end
end
