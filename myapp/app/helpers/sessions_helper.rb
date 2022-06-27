module SessionsHelper
  # cookieにユーザーIDを保存
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    session[:user_id].present?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
