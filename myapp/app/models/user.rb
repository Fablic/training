# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :login_id, presence: true
  has_secure_password
end
