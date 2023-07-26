class User < ApplicationRecord

    has_many :tasks

    validates :first_name, presence: true
    validates :username, presence: true
    validates :email, presence: true
    validates :password, presence: true
    validates :is_admin, presence: true
end
