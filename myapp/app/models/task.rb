# frozen_string_literal: true

class Task < ApplicationRecord # rubocop:disable Style/Documentation
<<<<<<< HEAD
  validates :title, presence: true
  validates :due_date, presence: true

  belongs_to :user
=======
  has_many :user_task_relations, dependent: :destroy
  has_many :user, through: :user_task_relations

>>>>>>> shinya-uchiamki-step9
  has_many :task_label_relations, dependent: :destroy
  has_many :labels, through: :task_label_relations

  enum status: { open: 0, in_progress: 1, closed: 2 }
  enum priority: { low: 0, medium: 1, high: 2 }
end
