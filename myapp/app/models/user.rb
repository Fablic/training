# == Schema Information
#
# Table name: users
#
#  id              :integer          unsigned, not null, primary key
#  email           :string(255)      not null
#  is_admin        :boolean          default(FALSE), not null
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: true }, format: {with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: 'is not a valid email format'}

  has_many :tasks, dependent: :destroy

  has_secure_password
end
