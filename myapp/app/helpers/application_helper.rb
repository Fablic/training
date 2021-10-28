module ApplicationHelper
  def adminer?
    current_user.role == User.roles['owner'] or current_user.role == User.roles['adminer']
  end

  def non_admin_redirect
    redirect_to root_url unless adminer?
  end
end
