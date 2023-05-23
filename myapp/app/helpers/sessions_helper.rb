module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def logout
    session[:user_id] = nil
    @current_user = nil
  end

  def require_login
    return if logged_in?
    redirect_to login_path, danger: t('session.need_login')
  end
end
