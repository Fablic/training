# frozen_string_literal: true

class User < ApplicationRecord
  DEFAULT_ROLE_VALUE = 0

  has_secure_password

  after_initialize :set_default_values

  has_many :tasks, inverse_of: :user, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true

  enum :role, {
    ordinary: 0, # 一般
    admin: 1     # 管理者
  }, prefix: true

  scope :find_list_by_admin, -> { where(role: 'admin') }

  def set_default_values
    self.role ||= DEFAULT_ROLE_VALUE
  end

  def admin?
    self.role == 'admin'
  end

  def ordinary?
    self.role == 'ordinary'
  end
end
