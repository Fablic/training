# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user

  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  enum status: {
    todo: 0,
    in_progress: 1,
    done: 2,
  }

  enum priority: {
    low: 25,
    middle: 50,
    high: 75,
  }

  validates :user, {
    presence: true,
  }

  validates :title, {
    presence: true,
    length: {
      maximum: 255,
    },
  }
  validates :description, {
    allow_blank: true,
    length: {
      maximum: 768,
    },
  }
  validates :status, {
    allow_blank: true,
    inclusion: { in: self.statuses.keys },
  }
  validates :priority, {
    allow_blank: true,
    inclusion: { in: self.priorities.keys },
  }
  scope :search_title, -> (title) { where('title LIKE ?', "%#{ApplicationRecord.sanitize_sql_like(title)}%") if title.present? }

  scope :search_status, ->(status) { where(status: status) if status.present? }

  scope :search_label, -> (label_id) { joins(:labels).where(labels: { id: label_id }) if label_id.present? }

  def self.search(params)
    search_title(params[:title]).search_status(params[:status]).search_label(params[:label_id])
  end
end
