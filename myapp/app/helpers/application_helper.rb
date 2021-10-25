module ApplicationHelper
  def current_user
    User.first
  end
end
