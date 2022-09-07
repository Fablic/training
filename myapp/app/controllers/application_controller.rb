class ApplicationController < ActionController::Base
  before_action :login_user
  before_action :re_login

  def login(user)
    token = User.create_login_token
    cookies[:login_token] = token
    user.update(login_token: User.encrypt_login_token(token))
    @login_user = user
  end

  def logout
    cookies.delete(:login_token)
    @login_user = nil
  end

  def login?
    @login_user.present?
  end

  def login_user
    if login?
      @login_user
    else
      token = User.encrypt_login_token(cookies[:login_token])
      @login_user ||= User.find_by(login_token: token)
    end
  end

  def re_login
    redirect_to(login_path) if !login?
  end
end
