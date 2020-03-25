# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :user_projects, dependent: :destroy
  has_many :user_login_managers, dependent: :destroy
  has_many :projects, through: :user_projects
end
