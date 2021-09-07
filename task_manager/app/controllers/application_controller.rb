# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper, AdminHelper
  before_action :authenticate_user

  def authenticate_user
    return if logged_in?

    flash[:danger] = I18n.t 'application.flash.authentification_user.danger'
    redirect_to('/login')
  end
end
