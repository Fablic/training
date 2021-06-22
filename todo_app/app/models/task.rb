# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 5000 }
  enum task_status: [:todo, :doing, :done]

  def self.search(keyword, status, sort_query)
    result_tasks = ::Task.all
    result_tasks = result_tasks.where('title like ?', keyword + '%') unless keyword.nil?
    result_tasks = result_tasks.where({ task_status: status }) unless status.nil?
    result_tasks.order(sort_query)
  end
end
