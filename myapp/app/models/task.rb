class Task < ApplicationRecord

  enum status: { not_started:0, in_progress: 1, completed: 2 }
  enum priority: { low:0, medium: 1, high: 2 }

  belongs_to :user
  belongs_to :assigned_user, :class_name => 'User', :foreign_key => 'assigned_user_id', optional: true

  has_many :tasks_labels
  has_many :labels, through: :tasks_labels

  validates :title, presence: true
end
