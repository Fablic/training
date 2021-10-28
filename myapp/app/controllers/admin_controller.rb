class AdminController < ApplicationController
  def index
    @users = User.all
  end
end
