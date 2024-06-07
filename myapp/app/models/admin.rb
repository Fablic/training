class Admin < ApplicationRecord
  has_many :users
  validates :user_id, uniqueness: { message: 'is already admin user!' }
end
