class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  validates :name, presence: true
  validates :personal_id, presence: true, uniqueness: { case_sensitive: true }
  validates :password, presence: true
  has_secure_password
  validate :user_admin_not_exist, on: :update
  before_destroy :user_admin_not_exist_destroy
  enum admin: { general: false, administ: true }

  def user_admin_not_exist
    if admin_was == 'administ' && User.where(admin: true).count == 1 && admin_changed? == true
      errors.add :danger, ''
    end
  end

  def user_admin_not_exist_destroy
    if admin == 'administ' && User.where(admin: true).count == 1
      raise error
    end
  end
end
