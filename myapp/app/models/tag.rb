class Tag < ApplicationRecord
  belongs_to :user
  has_many :task_tags
  has_many :tasks, through: :task_tags

  paginates_per 10
end
