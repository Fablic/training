# frozen_string_literal: true

class ApplicationController < ActionController::Base # rubocop:disable Style/Documentation
  include Authentication
  include Authorization

  before_action :require_sign_in!, :authorize_standard!

  private

  def after_sign_in_path_for(user)
    case user.role
    when 'admin'
      admin_users_path
    else
      root_path
    end
  end
end
