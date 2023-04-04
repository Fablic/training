# frozen_string_literal: true
class AdminsController < ApplicationController
  before_action :admin_user_checker

  private

  def admin_user_checker
    raise Forbidden , self if current_user.role_ordinary?
  end
end
