# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :logged_in_user, only: %i[profile edit_profile]
  before_action :logged_in_as_admin, only: %i[add index show]

  # the new method will be used to present the form to create users
  def new
    if user_logged_in?
      redirect_to root_path
    else
      @user = User.new
    end
  end

  # sign up
  def create
    if User.find_by(email: user_params[:email]).present?
      redirect_to signup_path, notice: 'User Already Registered!'
    else
      @user = User.create(user_params)
      if @user.save
        log_in @user
        redirect_to profile_path
      else
        redirect_to signup_path
      end
    end
  end

  def profile
    @user = User.find(current_user.id)
  end

  def edit_profile
  end

  # admin functions

  def index
    @users = User.order('created_at desc').page(params[:page]).per(5)
  end

  def show
    @user = User.find(params[:id])
  end

  # add new users by admin
  def add
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_logged_in? ? admin_users_list_path : profile_path, flash: { success: 'Updated' }
    else
      flash.now[:danger] = 'Failed'
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, flash: { success: 'Deleted' }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :role)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
