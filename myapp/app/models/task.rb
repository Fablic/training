# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: { yet_started: 0, being_worked: 1, done: 2 }

  scope :task_name_partial_search, -> (task_name) { where('task_name LIKE ?', "%#{task_name}%") }

  validates :task_name, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }
  validates :status, presence: true
  validate :ends_on_must_be_after_starts_on

  paginates_per 5

  belongs_to :user

  private

  def ends_on_must_be_after_starts_on
    return if starts_on.blank? || ends_on.blank?

    errors.add(:ends_on, :must_be_after_starts_on) if starts_on > ends_on
  end
end
