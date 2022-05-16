class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 255 }
  validates :termination_at, presence: true
  validate :termination_at_must_be_future
  validate :validate_priority
  validate :validate_status

  PRIORITY_LOW = 0
  PRIORITY_MIDDLE = 1
  PRIORITY_HIGH = 2

  STATUS_NOT_STARTED = 0
  STATUS_ON_PROGRESS = 1
  STATUS_DONE = 2

  scope :all_sort_by, ->(target, sort_type) { order({ "#{target}": sort_type }) }

  enum priority: { low: PRIORITY_LOW, middle: PRIORITY_MIDDLE, high: PRIORITY_HIGH }
  enum status: { not_started: STATUS_NOT_STARTED, on_progress: STATUS_ON_PROGRESS, done: STATUS_DONE }

  def priority=(value)
    super value
    @priority_backup = nil
  rescue ArgumentError => _e
    @priority_backup = value
    self[:priority] = nil
  end

  def status=(value)
    super value
    @status_backup = nil
  rescue ArgumentError => _e
    @status_backup = value
    self[:status] = nil
  end

  private

  def termination_at_must_be_future
    return if termination_at.blank? || termination_at > Time.now

    errors.add(:termination_at, :termination_at_must_be_future)
  end

  def validate_priority
    return errors.add(:priority, :invalid_value) if @priority_backup.present?

    errors.add(:priority, :blank) if priority.blank?
  end

  def validate_status
    return errors.add(:status, :invalid_value) if @status_backup.present?

    errors.add(:status, :blank) if status.blank?
  end
end
