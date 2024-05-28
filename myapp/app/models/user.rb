# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
