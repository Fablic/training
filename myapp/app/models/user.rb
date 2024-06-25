# frozen_string_literal: true

class User < ApplicationRecord # rubocop:disable Style/Documentation
  validates :role, presence: true, inclusion: { in: %w[standard admin] }
  validates :status, presence: true, inclusion: { in: %w[active inactive] }

  has_secure_password
  has_many :tasks, dependent: :destroy

  enum role: { standard: 0, admin: 1 }
  enum status: { active: 0, inactive: 1 }
end
