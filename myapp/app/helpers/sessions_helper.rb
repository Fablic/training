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

    flash[:danger] = I18n.t('need_login')
    redirect_to login_path
  end
end
