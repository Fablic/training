# frozen_string_literal: true

class Label < ApplicationRecord
  has_many :task_labels, dependent: :nullify
  has_many :tasks, through: :task_labels
  scope :active, -> { where(deleted: 0) }

  validates :name, { presence: true, length: { maximum: 20 } }
end
