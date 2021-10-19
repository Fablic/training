# frozen_string_literal: true

class Label < ApplicationRecord
  validates :name, { presence: true, length: { maximum: 100 } }
  validates :color, { presence: true, length: { is: 7 } }

  belongs_to :user, foreign_key: 'created_by'

  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels
end
