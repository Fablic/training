# frozen_string_literal: true

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password
  has_many :tasks, dependent: :delete_all

  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 6 }, format: { without: /\s/, message: I18n.t('errors.messages.space') }

  def self.search(params)
    output = self
    output = output.where('email LIKE ?', "%#{params[:email]}%") if params[:email].present?
    output
  end
end
