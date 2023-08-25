class User < ApplicationRecord
    ROLES = ["user", "admin"].freeze

    validates :username, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, confirmation: true, length: { minimum: 6 }
    validates :role, presence: true, inclusion: { in: ROLES }

    has_many :tasks
    has_secure_password
end
