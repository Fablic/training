# frozen_string_literal: true

class Task < ApplicationRecord

  enum status: { not_started: 0, wip: 1, completed: 2 }
  scope :search_status, -> (status) { where(status: status) if status.present? }
  scope :search_keyword, -> (keyword) { where(["(name like? OR description like?)", "%#{keyword}%", "%#{keyword}%"]) }
  scope :active, -> { where(deleted: 0) }

  validates :name, { presence: true, length: { maximum: 50 } }
  validates :description, length: { maximum: 2000 }
  validates :status, inclusion: { in: ['not_started', 'wip', 'completed']  }
  validates :start_at, presence: true, date: true
  validates :due_date_at, presence: true, date: true
  validate :start_end_check?

  def start_end_check?
    return if self.start_at.blank? || self.due_date_at.blank?

    errors.add(:due_date_at, I18n.t('dictionary.messages.invalid_date_diff')) unless
      self.start_at < self.due_date_at
  end

  def self.search(keyword, status)
    return active.search_status(status).search_keyword(keyword)
  end
end
