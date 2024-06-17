module UsersHelper
  def admin_user?
    User.find_by(id: session[:user_id]).admin
  end

  def redirect_if_not_admin
    redirect_to tasks_path, notice: 'No permissioin to access admin page!' unless admin_user?
  end
end
