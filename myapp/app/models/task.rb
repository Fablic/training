# frozen_string_literal: true

class Task < ApplicationRecord
  after_initialize :set_defaults
  attr_accessor :start_tmp

  enum status: {
    pending: 0,
    started: 1,
    finished: 2,
  }
  validates :created_by, { presence: true, numericality: { only_integer: true } }
  validates :name, { presence: true, length: { maximum: 75 } }
  validates :description, { length: { maximum: 1000 } }
  validates :status, { presence: true, inclusion: { in: Task.statuses.keys } }
  validates_with DateValidator

  belongs_to :user, foreign_key: 'created_by'
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  private

  def set_defaults
    self.status ||= :pending
  end

  def finished_at_is_after_started_at
    return if finished_at.blank? || started_at.blank?
    return if   finished_at.to_date >= started_at.to_date

    errors.add(:finished_at, I18n.t('earlier_date_error', start: Task.human_attribute_name(:started_at)))
  end

  def finished_at_cannot_be_in_the_past
    return if finished_at.to_date >= Time.zone.today.to_date

    errors.add(:finished_at,
               I18n.t('earlier_date_error', start: I18n.t(:today)))
  end
end
