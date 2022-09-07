# frozen_string_literal: true

class Task < ApplicationRecord
  DEFAULT_PRIORITY_VALUE = 1
  DEFAULT_STATUS_VALUE = 0

  after_initialize :set_default_values

  validates :name, presence: true, length: { maximum: 255 }

  enum :priority, {
    low: 0,    # 低
    normal: 1, # 普通
    high: 2    # 高
  }, prefix: true

  enum :status, {
    untouched: 0, # 未着手
    touched: 1,   # 着手中
    completed: 2  # 完了
  }, prefix: true

  def set_default_values
    self.priority ||= DEFAULT_PRIORITY_VALUE
    self.status   ||= DEFAULT_STATUS_VALUE
  end
end
