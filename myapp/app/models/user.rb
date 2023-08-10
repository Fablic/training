# frozen_string_literal: true

class User < ApplicationRecord # rubocop:todo Style/Documentation
  has_many :tasks # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'assigned_user_id' # rubocop:todo Rails/HasManyOrHasOneDependent

  validates :first_name, presence: true
  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :is_admin, presence: true
end
