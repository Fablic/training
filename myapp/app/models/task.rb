class Task < ApplicationRecord
  enum status: { not_started: 1, in_progress: 2, completed: 3 }
  enum priority: { low: 1, middle: 2, high: 3 }

  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validates :detail, presence: true
  validates :detail, length: { maximum: 100 }

  paginates_per 5

  scope :name_like, -> (name) { where('name LIKE ?', "%#{name}%") if name.present? }
  scope :status_equal, -> (status) { where('status = ?', status) if status.present? }

  belongs_to :user
end
