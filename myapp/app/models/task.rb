# frozen_string_literal: true

class Task < ApplicationRecord
  has_and_belongs_to_many :labels

  enum status: [:not_started, :in_progress, :completed]
  belongs_to :user, optional: false
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 30000 }
  validates :status, presence: true

  def self.enum_options_for_select_status
    self.statuses.map { |status, i| [I18n.t("activerecord.attributes.task.statuses.#{status}"), status] }
  end

  def self.search_title(search_query)
    Task.where("title LIKE ?", "%#{search_query}%")
  end

  def self.filter_status(status)
    Task.where(status: "#{status}")
  end

  def self.filter_labels(label_ids)
    Task.left_joins(:labels).where(labels: { id: label_ids }).group('tasks.id')
  end
end
