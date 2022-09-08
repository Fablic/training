# frozen_string_literal: true

class Task < ApplicationRecord
  # 結合キー
  belongs_to :user
  has_many :labels, dependent: :destroy

  # バリデーション
  validates :title, length: { minimum: 1, maximum: 128 }
  validates :content, length: { minimum: 1, maximum: 1024 }

  # ステータスEnum
  enum status: {
    not_started: '1',
    in_progress: '2',
    closed: '3',
  }

  # スコープ
  scope :where_title, -> (title) { where('title like ?', "%#{title}%") if title.present? }
  scope :where_label, -> (label) { where('labels.name like ?', "%#{label}%") if label.present? }
  scope :where_status, -> (status) { where(status: status) if status.present? }

  # ページ内要素数
  paginates_per 5
end
