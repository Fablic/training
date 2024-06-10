class Admin < ApplicationRecord
  validates :user_id, uniqueness: { message: 'is already admin user!' }
end
