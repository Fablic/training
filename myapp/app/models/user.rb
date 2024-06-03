class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
end
