# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { minimum: 2, maximum: 32 }
  enum priority: { Low: 1, Normal: 2, High: 3 }
  enum status: { TODO: 1, IN_PROGRESS: 2, DONE: 3 }
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  scope :search_by_name_or_description, -> (keyword) { where('name LIKE ? OR description LIKE ?', "#{keyword}%", "#{keyword}%") if keyword.present? }
  scope :search_by_status, -> (status) { where(status: status) if status.present? }
  scope :search_by_user_id, -> (user_id) { where(user_id: user_id) }
  scope :search_by_label, -> (label_id) { where(labels: { id: label_id }) if label_id.present? }
  scope :sortby, lambda { |column, direction|
    if column.blank? || direction.blank?
      order(created_at: :desc)
    else
      order("#{column}": direction.to_s)
    end
  }
  scope :include_labels, -> { includes(:labels) }
  scope :include_task_labels, -> { includes(:task_labels) }
  scope :search, lambda { |user_id:, status:, keyword:, label_id:, sort:, direction:|
    search_by_user_id(user_id)
    .search_by_status(status)
    .search_by_name_or_description(keyword)
    .search_by_label(label_id)
    .sortby(sort, direction)
    .include_labels
    .include_task_labels
  }
end
