# frozen_string_literal: true

class ApplicationController < ActionController::Base # rubocop:disable Style/Documentation
  include Authentication
  include Authorization

  before_action :check_maintenance_mode, :require_sign_in!, :authorize_standard_operation!

  private

  def after_sign_in_path_for(user)
    case user.role
    when 'admin'
      admin_users_path
    else
      root_path
    end
  end

  def after_change_role_path_for(user)
    if user.admin? && session[:operation_role] == 'admin'
      admin_users_path
    elsif user.standard? || session[:operation_role] == 'standard'
      root_path
    else
      session_path
    end
  end

  def check_maintenance_mode
    if File.exist?(Rails.root.join('tmp', 'maintenance.txt'))
      render file: Rails.root.join('public', 'maintenance.html'), layout:false, status: 503
    end
  end
end
