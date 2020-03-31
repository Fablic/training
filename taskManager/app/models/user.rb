class User < ApplicationRecord
  enum role: { general: 0, admin: 1 }

  has_many :tasks, dependent: :destroy

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    uniqueness: true,
    format: { with: VALID_EMAIL_REGEX }

  validates :first_name,
    presence: true,
    length: { maximum: 20 }

  validates :last_name,
    presence: true,
    length: { maximum: 20 }

  validates :role,
    presence: true

  before_destroy do
    unless check_exist_two_admin?
      errors.add(:base, I18n.t('validate.errors.messages.require_at_one_admin'))
      throw(:abort)
    end
  end

  validate proc {
    !check_exist_two_admin? && errors.add(:base, I18n.t('validate.errors.messages.require_at_one_admin'))
  }, on: :update, if: -> { self.role_was == 'admin' && self.general? }

  def check_exist_two_admin?
    User.where(role: :admin).count >= 2
  end

  def view_name
    last_name + ' ' + first_name
  end
end
