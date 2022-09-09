class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create; end
end
