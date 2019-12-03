# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: [:todo, :doing, :done]

  validates :title, :status, presence: true
  validates :title, length: { maximum: 250 }
  validates :status, inclusion: { in: statuses }
  validate :due_date_cannot_be_in_past

  scope :title_name_partial_match, -> (title) { where('title like ?', "%#{title}%") if title.present? }
  scope :status_equal, -> (status) { where(status: status) if status.present? }

  def due_date_cannot_be_in_past
    errors.add(:due_date, I18n.t('activerecord.errors.messages.past_time')) if due_date.present? && due_date < Time.zone.today
  end

  def self.search(params, sort_column)
    return Task.all.order(sort_column => :desc) unless params
    Task.title_name_partial_match(params[:title]).status_equal(params[:status]).order(sort_column => :desc)
  end
end
