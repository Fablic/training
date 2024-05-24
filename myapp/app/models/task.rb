# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: [:not_started, :in_progress, :completed]
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 30000 }
  validates :status, presence: true

  def self.enum_options_for_select_status
    self.statuses.map { |status, i| [I18n.t("activerecord.attributes.task.statuses.#{status}"), status] }
  end

  def self.search_title(search_query)
    @tasks = Task.where("title LIKE ?", "%#{search_query}%")
    @tasks
  end

  def self.filter_status(status)
    @tasks = Task.where(status: "#{status}")
    @tasks
  end
end
