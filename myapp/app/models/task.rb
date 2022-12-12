# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 40 }
  validates :description, length: { maximum: 500 }

  def self.search(conditions)
    tasks = Task.where('title LIKE?',"%#{conditions[:keyword]}%")
    if conditions[:status] =~ /^[0|1|2]$/
      tasks = tasks.where('status=?', conditions[:status]) 
    end
    tasks = tasks.order("#{conditions['sort_column']} #{conditions['sort_direction']}")

    tasks.present? ? tasks : {}
  end
end
