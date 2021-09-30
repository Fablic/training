class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :logged_in_user

  private
    def logged_in_user
      redirect_to login_url unless logged_in?
    end
end
