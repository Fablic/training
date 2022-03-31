# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: { yet_started: 0, being_worked: 1, done: 2 }

  scope :task_name_partial_search, -> (task_name) { where('task_name LIKE ?', "%#{task_name}%") if task_name.present? }
  scope :status_search, -> (status) { where(status: status) if status.present? }
  scope :label_name_search, -> (label_name) { joins(:labels).where('label_name LIKE ?', label_name.to_s) if label_name.present? }
  validates :task_name, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }
  validates :status, presence: true
  validate :ends_on_must_be_after_starts_on

  paginates_per 5

  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  private

  def ends_on_must_be_after_starts_on
    return if starts_on.blank? || ends_on.blank?

    errors.add(:ends_on, :must_be_after_starts_on) if starts_on > ends_on
  end
end
