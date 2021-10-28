class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update]
  before_action :set_user, only: %i[edit update destroy]
  before_action :new_role, only: %i[new create]
  before_action :editing_role, only: %i[edit update]

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to root_path, flash: { info: I18n.t('pages.users.flash.added') }
    else
      redirect_back fallback_location: new_user_path, flash: { validation_error: @user.errors.full_messages }
    end
  end

  def update
    if @user.update(user_edit_params)
      redirect_to root_path, flash: { info: I18n.t('pages.users.flash.edited') }
    else
      redirect_back fallback_location: edit_user_path, flash: { validation_error: @user.errors.full_messages }
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_path, flash: { info: I18n.t('pages.users.flash.deleted') }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_edit_params
    permit_params = ['name']
    permit_params.push('email') if @user.id == current_user.id
    permit_params.push('role') if adminer?
    params.require(:user).permit(permit_params.map(&:to_sym))
  end

  def set_user
    @user = User.find(params[:id])
  end

  def editing_role
    return if adminer?
    return if @user.id == current_user.id

    redirect_to(root_url) and return
  end

  def new_role
    redirect_to root_path and return if current_user.present?
  end
end
