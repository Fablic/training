class ApplicationController < ActionController::Base
  include SessionsHelper, TaskHelper, UsersHelper
end
