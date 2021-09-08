# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    before_action :set_user_by_id, only: %i[show edit update destroy]
    before_action :confirm_update, only: %i[update], if: proc { user_params['is_admin'] == 'false' }
    def index
      @users = User.includes(:tasks)
      .search_name(params[:keyword]).or(User.search_email(params[:keyword]))
      .page(params[:page]).per(5)
    end

    def show
    end

    def edit
    end

    def update
      return unless @user.update(user_params)

      flash[:success] = I18n.t('controllers.flash.success', model: User.model_name.human, action: I18n.t('controllers.action.update'))
      redirect_to [:admin, @user]
    end

    def destroy
      @user.destroy

      flash[:success] = I18n.t('controllers.flash.success', model: User.model_name.human, action: I18n.t('controllers.action.destroy'))
      redirect_to admin_users_path
    end

    private

    def set_user_by_id
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :is_admin)
    end

    def confirm_update
      return unless User.will_lose_administrators?(@user)

      flash[:danger] = I18n.t('admin.flash.confirm_update_admin.danger')
      redirect_to [:admin, @user]
    end
  end
end
