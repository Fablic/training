class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy

  MINIMUN_ADMIN_USER_COUNT = 1
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 8 }
  validate :validate_admin

  scope :all_sort_by, ->(target, sort_type) { order({ "#{target}": sort_type }) }

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
