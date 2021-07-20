class User < ApplicationRecord
  has_many :task_link, dependent: :destroy
  has_many :task, through: :task_link
end
