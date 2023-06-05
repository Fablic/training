module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end

  def admin_logged_in?
    logged_in? && current_user.admin?
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

  def require_admin_login
    return if admin_logged_in?

    redirect_to tasks_path, danger: t('error.messages.no_authority')
  end
end
