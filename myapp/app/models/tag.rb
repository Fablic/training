class Tag < ApplicationRecord
  belongs_to :user
  has_many :task_tags
  has_many :tasks, through: :task_tags

  validates :name, presence: true, length: { maximum: 20 }

  paginates_per 10
end
