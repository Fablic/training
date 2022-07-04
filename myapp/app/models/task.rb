class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels
  enum status: { not_select: '', not_started: 0, start: 1, completed: 2 }
  validates :title, presence: true, length: { maximum: 255 }

  scope :search, lambda { |title = '', status = ''|
                   where('title LIKE ? AND status LIKE ?',
                         "%#{Task.sanitize_sql_like(title)}%",
                         "%#{Task.sanitize_sql_like(status)}")
                 }
end
