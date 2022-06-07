class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  ADMIN_USER_MINIMUM_COUNT = 1

  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, { presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } }
  validate :at_least_minimum_number_admin
  before_destroy :validate_admin_num

  private
  
  def at_least_minimum_number_admin
    if admin_flg == 0 && User.where(admin_flg: 1).count == ADMIN_USER_MINIMUM_COUNT
      errors.add(:base, :at_least_minimum_number_admin)
    end
  end

  def validate_admin_num
    if admin_flg == 1 && User.where(admin_flg: 1).count == ADMIN_USER_MINIMUM_COUNT
      errors.add(:base, :at_least_minimum_number_admin)
      throw(:abort)
    end
  end
end
