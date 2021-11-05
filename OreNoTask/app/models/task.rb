# frozen_string_literal: true

class Task < ApplicationRecord
  has_one :users, dependent: :restrict_with_error
  extend Enumerize

  enumerize :status, in: { not_started: 0, wip: 1, completed: 2 }, default: :not_started, scope: true

  scope :search_status, -> (status) { where(status: status) if status.present? }
  scope :search_keyword, -> (keyword) { where(['(name like? OR description like?)', "%#{keyword}%", "%#{keyword}%"]) }
  scope :active, -> { where(deleted: 0) }
  scope :user, -> (user_id) { where(user_id: user_id) }
  scope :available, -> (user_id) { active.user(user_id) }

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

  def self.search(keyword, status, user, order)
    available(user).search_status(status).search_keyword(keyword).order(order)
  end

  def self.delete_tasks_by_user_id(user_id)
    tasks = active.find_by(user_id: user_id)

    return true if tasks.nil?

    tasks.update(deleted: 1) ? (return true) : (raise ActiveRecord::Rollback)
  end
end
