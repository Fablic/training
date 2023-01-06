# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    INITIAL_PASSWORD = '0000'

    before_action :set_user, only: %i[edit update destroy]

    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def create
      user_params.merge!('password' => INITIAL_PASSWORD, 'password_confirmation' => INITIAL_PASSWORD)
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: I18n.t('activerecord.actions.user.sign_up.success_message')
      else
        render :new
      end
    end

    def edit; end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: 'user updated successfully'
      else
        render :edit
        flash[:notice] = 'user update failed'
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: 'delete successfully'
    end

    private

    def user_params
      @user_params ||= params.require(:user).permit(:name, :email)
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end

