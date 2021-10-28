class AdminController < ApplicationController
  before_action :logged_in_user
  before_action :non_admin_redirect
  def index
    @users = User.all
  end
end
