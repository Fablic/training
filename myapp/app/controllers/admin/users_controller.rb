# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy]

    def index
      query = User.all
      query = query.page(search_params[:page])

      @users = query
    end

    def show; end

    def new
      @user = User.new
    end

    def edit; end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_users_path,
                    flash: { success: I18n.t('messages.create', model_name: I18n.t('activerecord.models.user')) }
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path,
                    flash: { success: I18n.t('messages.update', model_name: I18n.t('activerecord.models.user')) }
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy

      redirect_to admin_users_path,
                  flash: { success: I18n.t('messages.destroy', model_name: I18n.t('activerecord.models.user')) }
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    def search_params
      params.permit(:page)
    end
  end
end
