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
end
