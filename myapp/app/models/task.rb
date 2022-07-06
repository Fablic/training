# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { minimum: 2, maximum: 32 }
  enum priority: { Low: 1, Normal: 2, High: 3 }
  enum status: { TODO: 1, IN_PROGRESS: 2, DONE: 3 }

  scope :sort_created_desc, -> { order(created_at: 'DESC') }
  scope :sort_limit_asc, -> { order(limit: 'ASC') }
  scope :sort_limit_desc, -> { order(limit: 'DESC') }
  scope :name_or_description, -> (keyword) { where('name LIKE ? OR description LIKE ?', "%#{keyword}%", "%#{keyword}%") if keyword.present? }
  scope :status, -> (status) { where(status: status) if status.present? }

  scope :sortby, lambda { |column, direction|
    if column.blank? || direction.blank?
      order(created_at: 'DESC')
    else
      order("#{column}": direction.to_s)
    end
  }
end
