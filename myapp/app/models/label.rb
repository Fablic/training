class Label < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }

  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels
end
