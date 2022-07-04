class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels
  enum status: { not_select: nil, not_started: 0, start: 1, completed: 2 }
  validates :title, presence: true, length: { maximum: 255 }

  scope :search_title, lambda { |title|
                         if title.present?
                           where('title LIKE ?',
                                 "%#{Task.sanitize_sql_like(title)}%")
                         end
                       }
  scope :search_status, lambda { |status|
                          where(status: status) if status.present?
                        }
  scope :search_label, lambda { |label_names = []|
    if label_names.present?
      joins(:labels)
        .where(task_labels: {
                 labels: { name: label_names }
               })
    end
  }
end
