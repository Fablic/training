class User < ApplicationRecord
  has_secure_password
  include IdGenerator
  enum role: [:normal, :admin]
  has_many :tasks

end
