class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }
  validates :password, presence: true, length: { minimum: 8 }
  validate :validate_admin

  scope :all_sort_by, ->(target, sort_type) { order({ "#{target}": sort_type }) }

  MINIMUN_ADMIN_USER_COUNT = 1

  def admin=(value)
    super value

    raise ArgumentError unless [:true, :false].include?(value.to_s.to_sym)
  rescue ArgumentError, TypeError => _e
    @invalid_admin = -1
    self[:admin] = nil
  end

  def validate_admin
    return errors.add(:admin, :invalid_value) if @invalid_admin.present?
  end
end
