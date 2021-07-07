# frozen_string_literal: true

module AdminHelper
  def authenticate_admin_user
    redirect_to root_path unless current_user&.admin?
  end
end
