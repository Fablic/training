require 'time'

class Task < ApplicationRecord
  enum status: { pending: 0, in_progress: 1, completed: 2 }

  validates :title, length: { in: 5..30, too_short: 'please input more than %{count} characters', too_long: '%{count} characters is the maximum allowed' }
  validates :description, length: { in: 10..300, too_short: 'please input more than %{count} characters', too_long: '%{count} characters is the maximum allowed' }
  validates :due, presence: { message: 'must be specified!' }
  validates :status, presence: { message: 'must be selected!'}

  validate :due_cannot_be_earlier_than_now, if: :due_changed?

  def self.search_with_sort(query_title, query_status, sort_by, order)
    if query_status.empty?
      where('title LIKE ?', "%#{query_title}%").order("#{sort_by} #{order}")
    else 
      where('title LIKE ?', "%#{query_title}%").where(status: query_status).order("#{sort_by} #{order}")
    end
  end

  private 

  def due_cannot_be_earlier_than_now
    if due.present? && due < Time.zone.now.beginning_of_minute
      errors.add(:due, "can't be earlier than now!")
    end
  end
end
