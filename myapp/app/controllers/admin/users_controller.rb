class Admin::UsersController < ApplicationController
  def index
    @users = User.includes(:tasks).all
  end
end
