class Label < ApplicationRecord
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels

  validates :name, presence: true, length: { maximum: 25 }, uniqueness: { scope: :user_id, case_sensitive: true }
end
