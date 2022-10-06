# frozen_string_literal: true

module Admin
  class UsersController < AdminsController
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
      if exist_other_admin_user?
        @user.destroy

        redirect_to admin_users_path,
                    flash: { success: I18n.t('messages.destroy', model_name: I18n.t('activerecord.models.user')) }
      else
        redirect_to admin_users_path, flash: { danger: I18n.t('admin_page.destroy.no_one_admin') }
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :role)
    end

    def search_params
      params.permit(:page)
    end

    def exist_other_admin_user?
      return true if @user.ordinary?

      admin_user_count = User.find_list_by_admin.count - 1
      admin_user_count >= 1
    end
  end
end
