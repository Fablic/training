# frozen_string_literal: true

module UsersHelper
  def get_user_name(user_id)
    User.find(user_id).name if !user_id.nil? && User.where(id: user_id).present?
  end
end
