# frozen_string_literal: true

class Task < ApplicationRecord # rubocop:todo Style/Documentation
  enum status: { not_started: 0, in_progress: 1, completed: 2 }
  enum priority: { low: 0, medium: 1, high: 2 }

  belongs_to :user
  belongs_to :assigned_user, class_name: 'User', optional: true

  has_many :tasks_labels # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :labels, through: :tasks_labels

  validates :title, presence: true
end
