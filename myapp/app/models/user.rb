class User < ApplicationRecord
    ROLES = ["user", "admin"].freeze

    validates :username, presence: true
    validates :email, presence: true
    validates :password_hash, presence: true
    validates :role, presence: true, inclusion: { in: ROLES }

    has_many :tasks
end
