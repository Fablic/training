module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id 
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def require_login
    unless logged_in?
      redirect_to login_path, notice: 'You need to log in first!'
    end
  end
end
