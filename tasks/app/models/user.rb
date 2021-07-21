class User < ApplicationRecord
  has_many :task_links, dependent: :destroy
  has_many :tasks, through: :task_links
end
