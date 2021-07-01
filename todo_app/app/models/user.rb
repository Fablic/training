# frozen_string_literal: true

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

class User < ApplicationRecord
  before_create :fill_id

  has_secure_password
  validates :username,
            presence: true,
            length: { maximum: 20 },
            uniqueness: { case_sensitive: false }

  validates :email,
            presence: true,
            length: { maximum: 254 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :icon,
            length: { maximum: 2000 }
  enum role: { normal: 0, admin: 1 }
  has_many :tasks, dependent: :destroy

  def fill_id
    self.id = loop do
      uuid = SecureRandom.uuid
      break uuid unless self.class.exists?(id: uuid)
    end
  end
end
