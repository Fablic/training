class User < ApplicationRecord
  has_many :task_users, dependent: :destroy
  has_many :tasks, through: :task_users
end
