class Task < ApplicationRecord
  validates :title, presence: { message: 'Title must not be blank!' }
  validates :description, presence: { message: 'Description must not be blank!' }
  validates :due, presence: { message: 'Due must be specified!' }
end
