# == Schema Information
#
# Table name: users
#
#  id                                :bigint           not null, primary key
#  deleted_at                        :datetime
#  email                             :string(255)      not null
#  name                              :string(255)      not null
#  password_digest                   :string(255)      not null
#  role({0: "ordinary", 1: "admin"}) :integer          default(0), not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_name   (name)
#
class User < ApplicationRecord
  DEFAULT_ROLE_VALUE = 'ordinary'

  acts_as_paranoid
  has_secure_password
  has_many :tasks, inverse_of: :user, dependent: :destroy
  validates_length_of :password, minimum: 8
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :name, presence: true, length: { maximum: 255 }
  
  enum :role, {
    ordinary: 0, 
    admin: 1
  }, prefix: true

  after_initialize do
    self.role ||= DEFAULT_ROLE_VALUE
  end

  class << self
    def cnt_admin_user_except_current(user_id)
      where(role: 'admin').where.not(id: user_id).count
    end
  end
end
