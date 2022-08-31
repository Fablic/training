class Label < ApplicationRecord
  # 結合キー
  belongs_to :task

  # バリデーション
  validates :name, length: { minimum: 1, maximum: 64 }
end
