# frozen_string_literal: true

class Task < ApplicationRecord
  validates :created_by, { presence: true }
  validates :name, { presence: true, length: { maximum: 75 } }
  validates :description, { length: { maximum: 1000 } }
  validates :finished_at, { presence: true }
  # validates :status, { presence: true, numericality: { only_integer: true } }

  belongs_to :user, foreign_key: 'created_by'
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  enum status: {
    pending: 0,
    started: 1,
    finished: 2,
  }
end
