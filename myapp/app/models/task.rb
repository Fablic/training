class Task < ApplicationRecord
  belongs_to :user
  belongs_to :tag

  validates :title, presence: true
  validates :content, presence: true
  validates :priority, presence: true
  validates :status, presence: true
  validates :due_date, presence: true

end
