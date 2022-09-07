class Task < ApplicationRecord
  # 結合キー
  validates :title, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }

  # ステータスEnum
  enum status: {
    not_started: '1',
    in_progress: '2',
    closed: '3',
  }

  # scope
  scope :where_title, -> (title) { where('title LIKE ?', "%#{title}%") if title.present? }
  scope :where_status, -> (status) { where('status = ?', status) if status.present? }

  # pagenation
  paginates_per 5
end
