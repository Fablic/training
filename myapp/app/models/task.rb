# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true
  validates :body,  presence: true
  validates :finish_at, presence: true
  validates :status, presence: true
  belongs_to :user

  scope :desc, -> { order(created_at: :desc) }
  scope :finish_desc, -> { order(finish_at: :desc) }
  scope :asc, -> { order(created_at: :asc) }
  scope :finish_asc, -> { order(finish_at: :asc) }

  scope :search, ->(search_params) do
    return if search_params.blank?

    title_like(search_params[:title])
      .status_is(search_params[:status])
  end
  scope :title_like, ->(title) { where('title LIKE ?', "%#{title}%") if title.present? }
  scope :status_is, ->(status) { where(status: status) if status.present? }

  enum status: {
    untouched: 0,
    in_progress: 1,
    completion: 2
  }
end
