require 'time'

class Task < ApplicationRecord
  enum status: { pending: 0, in_progress: 1, completed: 2 }

  validates :title, length: { in: 5..30 }
  validates :description, length: { in: 10..300 }

  validate :due_cannot_be_earlier_than_now, if: :due_changed?

  belongs_to :user
  has_many :tasks_labels, dependent: :destroy
  has_many :labels, through: :tasks_labels

  def self.search_with_sort(query_title, query_status, sort_by, order)
    tasks = where('title LIKE ?', "%#{query_title}%")
    tasks = tasks..where(status: query_status) if query_status.present?
    tasks.order("tasks.#{sort_by} #{order}")
  end

  def self.search_by_label(label_id)
    if label_id.present?
      joins(:labels)
        .where(labels: { id: label_id} )
        .distinct
    else 
      all
    end
  end

  private 

  def due_cannot_be_earlier_than_now
    if due.present? && due < Time.zone.now.beginning_of_minute
      errors.add(:due)
    end
  end
end
