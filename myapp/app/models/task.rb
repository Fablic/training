class Task < ApplicationRecord

  validates :title, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }

    # ステータスEnum
    enum status: {
      not_started: '0',
      in_progress: '1',
      closed: '2',
    }

    scope :where_title, -> (title) { where('title like ?', "%#{title}%") if title.present? }
    scope :where_status, -> (status) { where(status: status) if status.present? }
  end
