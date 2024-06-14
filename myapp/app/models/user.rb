# frozen_string_literal: true

class User < ApplicationRecord # rubocop:disable Style/Documentation
  has_secure_password
  has_many :user_task_relations, dependent: :destroy
  has_many :task, through: user_task_relations
end
