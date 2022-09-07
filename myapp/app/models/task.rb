# frozen_string_literal: true

class Task < ApplicationRecord
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
end
