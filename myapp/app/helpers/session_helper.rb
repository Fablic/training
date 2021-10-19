module SessionHelper
  def log_in(user)
    session[:user_id] = user.id;
  end
  def login_user
    @login_user ||= User.find_by(id: session[:user_id])
  end
  def logged_in?
    !login_user.nil?
  end
  def log_out
    session.delete(:user_id)
    @login_user = nil
  end
end
