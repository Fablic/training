class User < ApplicationRecord
	has_many :tasks, dependent: :destroy

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, uniqueness: true, length: { maximum: 255 }, format: { with: User::VALID_EMAIL_REGEX }
	has_secure_password
end
