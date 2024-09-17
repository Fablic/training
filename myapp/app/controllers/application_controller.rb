# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper, UsersHelper

  private

  def redirect_to_login_path_if_not_logged_in
    unless logged_in?
      redirect_to login_path
    end
  end

  def redirect_to_root_path_if_logged_in
    if logged_in?
      redirect_to root_path
    end
  end

  def redirect_to_root_path_if_normal_role
    if current_user.role_normal?
      redirect_to root_path
    end
  end

  def redirect_to_maintenance
    @maintenance = Maintenance.last
    return if @maintenance.nil?

    if @maintenance.on?
      cur = DateTime.now
      if @maintenance.started_at <= cur && cur <= @maintenance.ended_at
        redirect_to maintenance_path
      end
    end
  end
end
