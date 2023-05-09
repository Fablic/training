class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :task_status
end
