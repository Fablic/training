class TaskLabel < ApplicationRecord
    # 結合キー
    belongs_to :task
    belongs_to :label
  end
