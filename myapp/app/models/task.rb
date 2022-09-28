class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels
  has_many :labels, through: :task_labels

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
  scope :where_label, -> (label_id) { where(labels: { id: label_id }) if label_id.present? }
  scope :get_ids, -> (title, label, status) { eager_load(:labels).where_title(title).where_status(status).where_label(label).select('tasks.id') }

  # ページ内要素数
  paginates_per 5
end
