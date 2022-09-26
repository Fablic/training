class Label < ApplicationRecord
  # 結合キー
  has_many :task_labels
  has_many :tasks, through: :task_labels

  # バリデーション
  validates :name, length: { minimum: 1, maximum: 64 }

  # ページ内要素数
  paginates_per 5
end
