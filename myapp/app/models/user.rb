class User < ApplicationRecord
  has_manhy :tasks, dependent: :destroy
end
