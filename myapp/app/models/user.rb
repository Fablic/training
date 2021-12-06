# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :delete_all
  has_secure_password
end
