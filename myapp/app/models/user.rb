class User < ApplicationRecord
  has_many :tasks, dependent: :destory
end
