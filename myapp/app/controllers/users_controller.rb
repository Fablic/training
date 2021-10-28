class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update]
  before_action :editing_authority, only: %i[edit update]

  def new
    redirect_to root_path and return if current_user.present?

    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    redirect_to root_path and return if current_user.present?

    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to root_path, flash: { info: I18n.t('pages.users.flash.added') }
    else
      redirect_back fallback_location: new_user_path, flash: { validation_error: @user.errors.full_messages }
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_path, flash: { info: I18n.t('pages.users.flash.edited') }
    else
      redirect_back fallback_location: edit_user_path, flash: { validation_error: @user.errors.full_messages }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def editing_authority
    redirect_to(root_url) and return unless User.find(params[:id]).id == current_user.id
  end
end
