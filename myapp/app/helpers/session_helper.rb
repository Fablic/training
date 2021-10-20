module SessionHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def login_user
    if (user_id = session[:user_id])
      @login_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token])
        log_in(user)
        @login_user = user
      end
    end
  end

  def logged_in?
    !login_user.nil?
  end

  def log_out
    forget(login_user)
    session.delete(:user_id)
    @login_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
