module SignInHelper
  def sign_in(current_user)
    remember_token  = SecureRandom.urlsafe_base64

    user_login_manager = UserLoginManager.new(
      remember_token: Digest::SHA256.hexdigest(remember_token.to_s),
      user_id: current_user.id,
      browser: 'Chorme',
      ip: '1.1.1.1'
    )

    user_login_manager.save
    cookies[:user_remember_token] = remember_token
  end
end
