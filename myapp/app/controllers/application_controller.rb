class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :login_user
  before_action :re_login
end
