# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: destroy

  validates :name, presence: true, uniqueness: true
  has_secure_password :passwork_digest
end
