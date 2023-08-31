# frozen_string_literal: true

class Label < ApplicationRecord # rubocop:todo Style/Documentation

  has_many :tasks_labels
  has_many :tasks, through: :tasks_labels

  validates :name, presence: true
end
