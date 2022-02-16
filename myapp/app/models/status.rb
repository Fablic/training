class Status < ApplicationRecord
  has_many :task
  belongs_to :board
end
