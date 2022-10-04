# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, inverse_of: :user, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
end
