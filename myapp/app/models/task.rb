# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  enum priority: {Low: 1, Normal: 2, High: 3}
  enum status: {TODO: 1, IN_PROGRESS: 2, DONE: 3}

  before_destroy :ensure_not_in_progress

  private
  def ensure_not_in_progress
    if IN_PROGRESS?
      errors.add(:base, 'task is in progress')
      throw :abort
    end
  end
end
