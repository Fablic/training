module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # 現在ログイン中のユーザーを返却
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # 受け取ったユーザーがログイン中のユーザーと一致するかどうか
  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil?
  end
end
