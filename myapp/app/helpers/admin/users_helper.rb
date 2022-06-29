module Admin::UsersHelper
  def admin?
    current_user.role == 'admin'
  end
end
