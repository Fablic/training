module SessionHandling
  def current_user
    return @current_user if defined?(@current_user)

    @current_user = session[:user_id]&.then { |id| User.find_by(id: id) }
  end

  def current_user!
    current_user or raise '`current_user` is expected not to be `nil` in this context.'
  end

  def login(user)
    reset_session
    session[:user_id] = user.id
  end

  def require_login
    redirect_to login_path(I18n.locale), flash: { error: I18n.t('common.flash.login_required') } unless current_user
  end
end
