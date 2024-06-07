# frozen_string_literal: true

class User < ApplicationRecord # rubocop:disable Style/Documentation
  has_secure_password
  has_many :tasks, dependent: :destroy
end
