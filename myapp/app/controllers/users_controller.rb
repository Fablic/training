class UsersController < ApplicationController
  def index
    @users = User.all.includes(:tasks)
  end
end
