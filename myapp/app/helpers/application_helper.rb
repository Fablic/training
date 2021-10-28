module ApplicationHelper
  def adminer?
    current_user.authority == User.authoritys['owner'] or current_user.authority == User.authoritys['adminer']
  end

  def non_admin_redirect
    redirect_to root_url unless adminer?
  end

  def admin_controller?
    controller_name == 'admin'
  end
end
