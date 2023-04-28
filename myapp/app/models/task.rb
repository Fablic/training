class Task < ApplicationRecord
  validates :title, presence: true

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :task_status
end
