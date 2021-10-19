# frozen_string_literal: true

require 'bcrypt'

class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy, foreign_key: 'created_by'

  alias_attribute :password_digest, :pw
  validates :name, { presence: true, length: { maximum: 100 } }
  validates :username, { presence: true, length: { maximum: 100 } }
end
