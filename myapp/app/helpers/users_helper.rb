module UsersHelper
  def admin_user?(id)
    Admin.exists?(user_id: id)
  end

  def require_admin_user
    redirect_to tasks_path, notice: 'No permission to admin page' unless admin_user?(session[:user_id])
  end
end
