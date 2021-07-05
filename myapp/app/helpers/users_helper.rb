module UsersHelper
  def get_user_name(user_id)
    User.find(user_id).name if !user_id.nil?
  end

  def get_all_users
    User.select(:name, :id)
  end
end
