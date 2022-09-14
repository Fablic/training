class Task < ApplicationRecord
  # 結合キー
  belongs_to :user
  has_many :tasks_labels, dependent: :destroy
  has_many :labels, through: :tasks_labels

  # バリデーション
  validates :title, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }

  # ステータスEnum
  enum status: {
    not_started: '1',
    in_progress: '2',
    closed: '3',
  }

  # scope
  scope :search, -> (title, status, label_id) { eager_load(:labels).eager_load(:tasks_labels).where_title(title).where_status(Task.statuses[status]).where_label(label_id) }
  scope :where_title, -> (title) { where('title LIKE ?', "%#{title}%") if title.present? }
  scope :where_status, -> (status) { where('status = ?', status) if status.present? }
  scope :where_label, -> (label_id){ where(labels: { id: label_id }).left_outer_joins(:labels) if label_id.present? }

  # pagenation
  paginates_per 5
end
