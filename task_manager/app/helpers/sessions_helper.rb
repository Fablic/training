module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def logged_in?
    !current_user.nil?
  end

  def permission_confirmation(id)
    if !(id == current_user.id)
      flash[:danger] = '権限がありません。'
      redirect_back(fallback_location: root_path)
    end
  end
end
