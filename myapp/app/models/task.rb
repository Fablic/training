class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 171 }
  validates :description, length: { maximum: 1024 }
  validates :status, presence: true
  enum status: { new: 0, progress: 1, complete: 2 }, _prefix: :status
  belongs_to :user
  has_and_belongs_to_many :labels
end
