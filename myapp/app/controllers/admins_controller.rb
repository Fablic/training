# frozen_string_literal: true

class AdminsController < ApplicationController
  before_action :check_admin_user

  private

  def check_admin_user
    raise ActionController::RoutingError, self if current_user.role_ordinary?
  end
end
