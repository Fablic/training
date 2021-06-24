# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 5000 }
  enum task_status: [:todo, :doing, :done]

  scope :where_status, ->(status) { where(tasks: { status: status }) if status.present? }
  scope :where_keyword, ->(keyword) { where('title like ?', keyword + '%') if keyword.present? }

  def self.search(keyword, status, sort_query)
    where_keyword(keyword).where_status(status).order(sort_query)
  end
end
