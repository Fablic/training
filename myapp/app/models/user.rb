# frozen_string_literal: true

class User < ApplicationRecord
  before_create do
    self.password = EncryptionService.encrypt(self.password)
  end

  has_many :tasks, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true

  def self.authenticate(email, password)
    @user = User.find_by_email(email)
    if @user && EncryptionService.decrypt(@user[:password]) == password
      @user
    else
      nil
    end
  end
end
