# frozen_string_literal: true

class User < ApplicationRecord
  before_create do
    self.password = EncryptionService.encrypt(self.password)
  end

  before_destroy :ensure_at_least_one_admin_remains
  before_update :ensure_at_least_one_admin_remains, if: :role_changed_to_general?

  enum role: [:admin, :general]
  has_many :tasks, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  def self.authenticate(email, password)
    @user = User.find_by_email(email)
    if @user && EncryptionService.decrypt(@user[:password]) == password
      @user
    else
      nil
    end
  end

  def self.enum_options_for_select_role
    self.roles.map { |role, i| [I18n.t("activerecord.attributes.user.roles.#{role}"), role] }
  end

  private

  def ensure_at_least_one_admin_remains
    puts 'ensure_at_least_one_admin_remains called'
    puts User.where(role: 'admin').count <= 1
    puts self.role != 'admin'
    puts 'ensure_at_least_one_admin_remains called END'
    if self.role == 'general' && User.where(role: 'admin').count <= 1
    # if role == 'admin' && User.where(role: 'admin').count <= 1
      errors.add(:base, "Cannot delete the last admin user.")
      throw(:abort)
    end
  end

  def role_changed_to_general?
    role_changed? && self.role == 'general'
  end
end
