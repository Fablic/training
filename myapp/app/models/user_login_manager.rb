class UserLoginManager < ApplicationRecord
  belongs_to :user

  validates_uniqueness_of :user_id, :scope => [:ip, :browser]

  class << self

    def create!(user_id:, request:)
      remember_token  = new_remember_token
      user_login_manager = UserLoginManager.new(
        remember_token: encrypt(remember_token),
        user_id: user_id,
        browser: request.env["HTTP_USER_AGENT"],
        ip: request.remote_ip
      )
      user_login_manager.save
      remember_token
    end

    def auth(remember_token:, request:)
      remember_token = encrypt(remember_token)
      user_login_manager = UserLoginManager.find_by(remember_token: remember_token)
      return nil if user_login_manager.blank?

      return user_login_manager.user if user_login_manager.ip == request.remote_ip && user_login_manager.browser == request.env["HTTP_USER_AGENT"]

      nil
    end

    private

    def encrypt(token)
      Digest::SHA256.hexdigest(token.to_s)
    end

    def new_remember_token
      SecureRandom.urlsafe_base64
    end
  end

end
