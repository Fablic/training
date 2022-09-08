class User < ApplicationRecord
  has_many :tasks, dependent: :delete_all
end
