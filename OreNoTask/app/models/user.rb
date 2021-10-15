# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  extend Enumerize

  enumerize :privilege, in: { user: 0, admin: 1 }, default: :user, scope: true

  scope :active, -> { where(deleted: 0) }
  scope :active_user_count, -> (name) { active.where(name: name).count }

  validates :name, { presence: true, length: { maximum: 20 } }
  validates :password, { presence: true, length: { maximum: 20 } }
  validate :unique_user?

  def unique_user?

    errors.add(:name, I18n.t('dictionary.messages.invalid_unique_name')) unless
      User.active_user_count(name) == 0
  end
end
