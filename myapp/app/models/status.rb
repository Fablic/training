class Status < ApplicationRecord
  has_many :task
  has_many :status_step, foreign_key: 'from_status_id'
  has_many :to_status, through: :status_step

  belongs_to :board
end
