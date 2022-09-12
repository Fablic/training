class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }

  # ステータスEnum
  enum status: {
    not_started: '0',
    in_progress: '1',
    closed: '2',
  }

  # スコープ
  scope :where_title, -> (title) { where('title like ?', "%#{title}%") if title.present? }
  scope :where_status, -> (status) { where(status: status) if status.present? }
  scope :where_user_id, -> (user_id) { where(user_id: user_id) if user_id.present? }

  # ページ内要素数
  paginates_per 5
end
