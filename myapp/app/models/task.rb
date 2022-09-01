# frozen_string_literal: true

class Task < ApplicationRecord
  # user対応コメントアウト
  # # 結合キー
  # belongs_to :user

  # バリデーション
  validates :title, length: { minimum: 1, maximum: 128 }
  validates :content, length: { minimum: 1, maximum: 1024 }
  validates :label, length: { minimum: 1, maximum: 64 }

  # ステータスEnum
  enum status: {
    not_started: '1',
    in_progress: '2',
    closed: '3',
  }

  # スコープ
  scope :where_title, -> (title) { where('title like ?', "%#{title}%") if title.present? }
  scope :where_status, -> (status) { where(status: status) if status.present? }

  def self.search(title, status)
    order = 'tasks.created_at desc';
    return Task.where_title(title).where_status(status).order(order);
  end
end
