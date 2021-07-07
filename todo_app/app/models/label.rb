# frozen_string_literal: true

class Label < ApplicationRecord
  validates :name,
            presence: true,
            length: { maximum: 50 },
            uniqueness: { case_sensitive: false }

  enum color: { info: 0, success: 1, warning: 2, danger: 3 }

  has_many :task_labels, dependent: :restrict_with_error
  has_many :tasks, through: :task_labels
end
