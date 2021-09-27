class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  enum status: {
    todo: 0,
    in_progress: 1,
    done: 2
  }, _prefix: true

  enum priority: {
    low: 0,
    medium: 1,
    high: 2
  }, _prefix: true

  validates :name, presence: true
  validates :name, length: { maximum: 255 }
  validates :priority, inclusion: { in: priorities.keys }
  validates :status, inclusion: { in: statuses.keys }

  scope :search_by_name, ->(keyword) { where('name LIKE ?', "%#{keyword}%") }
  scope :search_by_status, ->(status) { where(status: status)}
end
