# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  extend Enumerize

  enumerize :privilege, in: { user: 0, admin: 1 }, default: :user, scope: true

  scope :active, -> { where(deleted: 0) }
  scope :active_user_count, -> (name) { active.where(name: name).count }

  validates :name, { presence: true, length: { maximum: 20 } }
  validates :password, { presence: true, length: { maximum: 20 }, on: :create }
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
end
