# frozen_string_literal: true

class Task < ApplicationRecord
  enum priority: {
    low: 0, # 優先度低
    normal: 1, # 優先度中
    high: 2, # 優先度高
  }

  enum progress: {
    Todo: 0,
    InProgress: 1,
    Done: 2,
  }

  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate :due_at_is_valid_datetime
  validates :priority, inclusion: { in: Task.priorities.keys }
  validates :progress, inclusion: { in: Task.progresses.keys }

  with_options if: :due_at? do
    validate :due_at_start_check
  end

  def due_at_is_valid_datetime
    errors.add(:due_at, :invalid_datetime) if begin
      due_at.in_time_zone
    rescue StandardError
      ArgumentError
    end == ArgumentError
  end

  def due_at_start_check
    errors.add(:due_at, :start_check) if due_at < Time.current
  end
  
  def self.search(keyword)
    where(["name like?", "%#{keyword}%"])
  end
end
