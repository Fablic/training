class User < ApplicationRecord
  has_secure_password
  include IdGenerator
  enum role: [:normal, :admin]

end
