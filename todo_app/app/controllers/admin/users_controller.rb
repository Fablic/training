# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    include AdminConcern
    layout 'admin'
    before_action :find_user, only: %i[show edit update destroy]
    before_action :authenticate_admin_user

    def index
      @users = User.eager_load(:tasks).order({ created_at: :desc })
                   .page(params[:page])
    end

    def new
      @user = User.new
    end

    def show; end

    def edit; end

    def create
      @user = User.new(users_param)
      if @user.save
        redirect_to admin_users_path, { flash: { success: I18n.t(:'message.registered_user') } }
      else
        flash.now[:error] = I18n.t(:'message.registered_is_failed')
        render :new
      end
    end

    def update
      if @user.update(users_param)
        flash[:success] = I18n.t(:'message.registered_user')
        redirect_to admin_users_path
      else
        flash.now[:error] = I18n.t(:'message.edited_is_faild')
        render :edit
      end
    end

    def destroy
      return if @user == current_user

      if @user.destroy
        flash[:success] = I18n.t(:'message.deleted_user')
        redirect_to admin_users_path
      else
        flash.now[:error] = I18n.t(:'message.deleted_is_failed')
        render admin_users_path
      end
    end

    private

    def users_param
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :icon, :role)
    end

    def find_user
      @user = User.left_joins(:tasks).find(params[:id])
    end
  end
end
