# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, -> { where(deleted: 0) }, dependent: :restrict_with_error
  has_secure_password
  extend Enumerize

  enumerize :privilege, in: { user: 0, admin: 1 }, default: :user, scope: true

  scope :active, -> { where(deleted: 0) }
  scope :active_user_count, -> (name) { active.where(name: name).count }
  scope :admin_user_count, -> { active.where(privilege: 1).count }

  validates :name, { presence: true, length: { maximum: 20 } }
  validates :password, { presence: true, length: { maximum: 20 }, on: :create }
  validates :privilege, { presence: true }
  validate :unique_user, { on: :create }
  validate :password_on_update, { on: :update }

  def unique_user
    errors.add(:name, I18n.t('dictionary.messages.name_not_unique')) unless
      User.active_user_count(name).zero?
  end

  def password_on_update
    errors.add(:name, I18n.t('dictionary.messages.over_length_password_on_update')) unless
      self.password.blank? || self.password.length < 20
  end

  def self.delete_user(user_id)
    user = active.find(user_id)

    return true if user.nil?

    user.update!(deleted: 1)
  end

  def self.delete_user_and_tasks(user_id)
    ActiveRecord::Base.transaction do
      Task.delete_tasks_by_user_id(user_id)
      delete_user(user_id)
    end

    true
  rescue StandardError
    false
  end

  def self.last_admin?(user_id)
    @user = User.active.find(user_id)
    @user.privilege == 1 && User.admin_user_count == 1
  end
end
