# frozen_string_literal: true

class Label < ApplicationRecord
  belongs_to :user
  has_many :task_labels
  has_many :tasks, through: :task_labels

  validates :name, presence: true
end
