# frozen_string_literal: true

class User < ApplicationRecord # rubocop:todo Style/Documentation
  has_secure_password

  before_save :downcase_email

  has_many :tasks # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'assigned_user_id' # rubocop:todo Rails/HasManyOrHasOneDependent

  validates :first_name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, confirmation: true, length: { maximum: 255 }
  validates :password_digest, presence: true, confirmation: true, length: { minimum: 8 }

  private

  def downcase_email
    self.email = email.downcase
  end
end
