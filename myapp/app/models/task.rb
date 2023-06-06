class Task < ApplicationRecord
  belongs_to :user

  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings

  validates :title, presence: true, length: { maximum: 30 }
  validates :deadline, presence: true

  enum status: { not_started: 0, start: 1, completed: 2 }

  scope :where_title, -> (title) { where('title like ?', "%#{title}%") if title.present? }
  scope :where_status, -> (status) { where(status: status) if status.present? }

  scope :deadline_order, -> (sort) { %w[asc desc].include?(sort) ? order(deadline: sort) : order(created_at: :DESC) }

  scope :search_label, -> (label) { joins(:labels).where(labels: { id: label }) if label.present? }
end
