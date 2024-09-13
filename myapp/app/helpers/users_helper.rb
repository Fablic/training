module UsersHelper
  def is_admin?(user)
    User.roles[user.role] == User.roles[:role_admin]
  end

  def is_moderator?(user)
    User.roles[user.role] == User.roles[:role_moderator]
  end

  def is_normal?(user)
    User.roles[user.role] == User.roles[:role_normal]
  end
end
