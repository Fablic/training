# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :find_user, only: %i[edit update destroy tasks]

    def index
      @users = User.search(params).page(params[:page])
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_root_url, flash: { success: create_flash_message('create', 'success') }
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_root_url, flash: { success: create_flash_message('update', 'success') }
      else
        render :edit
      end
    end

    def destroy
      if @user == current_user
        flash[:danger] = I18n.t('flash.user_self_destroy')
      elsif @user.destroy
        flash[:success] = create_flash_message('update', 'success')
      else
        flash[:danger] = create_flash_message('destroy', 'failed')
      end

      redirect_to admin_root_url
    end

    def tasks
      @tasks = Task.search(params, @user.tasks).order("#{params[:sort_column] || 'created_at'} #{params[:sort_direction] || 'desc'}").page(params[:page])
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def find_user
      @user = User.find(params[:id])
    end

    def create_flash_message(action, result)
      I18n.t("flash.#{result}", target: "#{User.model_name.human}「#{@user.email}」", action: I18n.t("actions.#{action}"))
    end
  end
end
