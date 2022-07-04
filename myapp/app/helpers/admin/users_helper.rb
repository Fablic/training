module Admin::UsersHelper
  def admin?
    current_user.admin?
  end
end
