class User < ApplicationRecord
    has_many :tasks, dependent: :destroy
    has_secure_password
end
