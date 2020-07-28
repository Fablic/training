# frozen_string_literal: true

class LoginForm
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :name, presence: true, length: { maximum: 100 }, allow_blank: false
  validates :pass, presence: true, allow_blank: false

  attr_accessor :name, :pass
end
