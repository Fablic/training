# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user

  def index
    @users = User.active.order("name asc").page(params[:page]).per(10)
  end
end