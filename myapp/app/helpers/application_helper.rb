module ApplicationHelper
  def adminer?
    current_user.owner? or current_user.adminer?
  end

  def non_admin_redirect
    redirect_to root_url and return unless adminer?
  end
end
