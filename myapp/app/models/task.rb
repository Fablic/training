class Task < ApplicationRecord
  enum priority: { low: 0, medium: 1, high: 2 }
  enum status:   { to_do: 0, in_progress: 1, done: 2 }

  validates :name, presence: true, length: { maximum: 256 }
  validates :priority, presence: true
  validates :status, presence: true
  validates :deadline, presence: true
  validate :deadline_not_in_past

  private

  def deadline_not_in_past
    return if deadline.blank?
    if deadline < Time.current
      errors.add(:deadline, I18n.t("errors.messages.deadline_in_past"))
    end
  end
end
