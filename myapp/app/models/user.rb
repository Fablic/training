# frozen_string_literal: true

require 'bcrypt'

class User < ApplicationRecord
  has_secure_password
  alias_attribute :password_digest, :pw
  validates :name, { presence: true, length: { maximum: 100 } }
  validates :username, { presence: true, length: { maximum: 100 } }
  validates :admin, { presence: true }
end
