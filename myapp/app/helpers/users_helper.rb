module UsersHelper
  def get_user_name(user_id)
    unless user_id.nil?
      unless User.where(:id => user_id).blank?
        User.find(user_id).name
      end
    end
  end

end
