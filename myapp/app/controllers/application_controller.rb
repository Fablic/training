class ApplicationController < ActionController::Base
  include SessionsHelper
  include FunctionsHelper

  before_action :login_user
  before_action :re_login
  before_action :check_system_started
end
