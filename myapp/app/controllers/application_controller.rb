class ApplicationController < ActionController::Base
    include SessionsHelper

    before_action :login_user
  end
