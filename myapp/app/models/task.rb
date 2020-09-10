# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 256 }
  validates :status, presence: true

  enum status: {
    open: 0, # 未着手
    doing: 1, # 着手中
    done: 2, # 完了
  }

  def self.sort_task_by(sort, direction)
    sort ||= 'created_at'
    direction ||= 'desc'

    self.order("#{sort} #{direction}")
  end
end
