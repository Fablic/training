class Label < ApplicationRecord
  # 結合キー
  has_many :tasks_labels, dependent: :destroy
  has_many :tasks, through: :tasks_labels
end
