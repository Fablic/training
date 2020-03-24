# frozen_string_literal: true

class Task < ApplicationRecord
  has_rich_text :description

  belongs_to :group
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  validates :name, presence: true
  validates :priority, presence: true
  validates :group_id, presence: true
  validate :verify_end_period_at

  enum priority: { high: 0, middle: 1, low: 2 }

  private

  def verify_end_period_at
    return if end_period_at.blank? || Date.current <= end_period_at

    errors.add(:end_period_at, I18n.t('validate.errors.tasks.end_period_at_is_old_than_current'))
  end
end
