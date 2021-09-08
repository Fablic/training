# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  scope :search_name, -> (keyword_name) { where(['name like?', "%#{keyword_name}%"]) }
  scope :search_email, -> (keyword_email) { where(['email like?', "%#{keyword_email}%"]) }

  def self.will_lose_administrators?(user)
    return User.only_one_admin? if user.is_admin

    return false
  end

  def self.only_one_admin?
    User.where(is_admin: true).size <= 1
  end
end
