class ApplicationController < ActionController::Base
  before_action :login_user
  before_action :re_login
  before_action :check_system_started

  def login(user)
    token = User.create_login_token
    session[:login_token] = token
    user.update(login_token: User.encrypt_login_token(token))
  end

  def logout
    session.delete(:login_token)
  end

  def login_user
    if session[:login_token].present?
      @login_user ||= User.find_by(login_token: User.encrypt_login_token(session[:login_token]))
    end
    @login_user
  end

  def re_login
    redirect_to(login_path) if login_user.nil?
  end

  def check_system_started
    if Function.is_stopped?(Function::FUNC_ID_SYSTEM)
      render(
        file: Rails.public_path.join("503.html"),
        content_type: "text/html",
        layout: false,
        status: :service_unavailable,
      )
    end
  end
end
