class Task < ApplicationRecord
  belongs_to :user
  has_many :task_label_attachments, dependent: :destroy
  has_many :labels, through: :task_label_attachments

  validates :name, presence: true
  validates :description, presence: true

  # NOTE: Set sporadic numbers in case new values are included in the future.
  enum priority: { low: 5, normal: 10, high: 20 }
  enum status: { waiting: 5, doing: 10, done: 20 }

  scope :name_with, ->(name) { where('name LIKE ?', "%#{ApplicationRecord.sanitize_sql_like(name)}%") }
end
