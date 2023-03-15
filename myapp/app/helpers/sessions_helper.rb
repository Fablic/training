module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    current_user.present?
  end

  def admin_logged_in?
    logged_in? && current_user&.is_admin?
  end

  def logout
    session[:user_id] = nil
    @current_user = nil
  end

  def require_login
    unless logged_in?
      flash[:danger] = I18n.t('need_login')
      redirect_to login_path
    end
  end

  def require_admin_login
    if !admin_logged_in?
      flash[:danger] = I18n.t('need_admin_login')
      return redirect_to tasks_path
    end
  end
end
