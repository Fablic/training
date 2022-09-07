class ApplicationController < ActionController::Base
  before_action :login_user
  before_action :re_login

  def login(user)
    token = User.create_login_token
    session[:login_token] = token
    user.update(login_token: User.encrypt_login_token(token))
  end

  def logout
    session.delete(:login_token)
  end

  def login_user
    User.find_by(login_token: User.encrypt_login_token(session[:login_token]))
  end

  def re_login
    redirect_to(login_path) if login_user.nil?
  end
end
