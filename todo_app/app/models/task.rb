# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 5000 }
  enum task_status: { todo: 0, doing: 1, done: 2 }
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  scope :where_status, ->(status) { where(tasks: { task_status: status }) if status.present? }
  scope :where_keyword, ->(keyword) { eager_load(:labels).where('title LIKE ? OR labels.name LIKE ?', "#{keyword}%", "#{keyword}%") if keyword.present? }
  scope :where_user_id, ->(user_id) { where(tasks: { user_id: user_id }) if user_id.present? }

  def self.search(keyword, status, user_id, sort_query)
    where_keyword(keyword)
      .where_user_id(user_id)
      .where_status(status)
      .order(sort_query)
  end
end
