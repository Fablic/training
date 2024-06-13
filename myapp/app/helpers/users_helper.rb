module UsersHelper
  def admin_user?(id)
    User.find_by(id: id).admin
  end

  def redirect_if_not_admin
    redirect_to tasks_path, notice: 'No permissioin to access admin page!' unless admin_user?(session[:user_id])
  end
end
