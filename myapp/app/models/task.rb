# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  enum status: %i[todo processing done]

  scope :name_like, ->(name) { where('name like ?', "%#{name}%") if name.present? }
  scope :status_is, ->(status) { where(status: status.to_i) if status.present? }
  scope :sort_by_column, ->(column, sort) { order((column.presence || 'created_at').to_sym => (sort.presence || 'desc').to_sym) }

  def readable_status
    Task.human_attribute_name("status.#{self.status}")
  end

  def self.readable_statuses
    Task.statuses.map { |k, v| [Task.human_attribute_name("status.#{k}"), v] }.to_h
  end

  def readable_deadline
    self.deadline.presence || I18n.t(:no_deadline)
  end
end
