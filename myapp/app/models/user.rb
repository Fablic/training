class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  ADMIN_USER_MINIMUM_COUNT = 1
  NORMAL_USER = 0
  ADMIN_USER = 1

  has_many :tasks, dependent: :destroy
  has_many :labels, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, { presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } }
  validate :at_least_minimum_number_admin, on: :update
  before_destroy :validate_admin_num

  private

  def at_least_minimum_number_admin
    return unless admin_flg == NORMAL_USER && User.where(admin_flg: ADMIN_USER).count == ADMIN_USER_MINIMUM_COUNT

    errors.add(:base, :at_least_minimum_number_admin)
  end

  def validate_admin_num
    return unless admin_flg == ADMIN_USER && User.where(admin_flg: ADMIN_USER).count == ADMIN_USER_MINIMUM_COUNT

    errors.add(:base, :at_least_minimum_number_admin)
    throw(:abort)
  end
end
