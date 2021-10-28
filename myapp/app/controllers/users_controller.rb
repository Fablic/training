class UsersController < ApplicationController
  skip_before_action :logged_in_user, only: %i[new create]
  before_action :set_user, only: [ :edit,:update,:destroy] 
  before_action :new_authority, only: %i[new create]
  before_action :editing_authority, only: %i[edit update]

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to root_path, flash: { info: I18n.t('pages.users.flash.added') }
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_edit_params)
      redirect_to root_path, flash: { info: I18n.t('pages.users.flash.edited') }
    else
      render 'edit'
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
    permit_params.push('authority') if is_adminer?
    params.require(:user).permit(permit_params.map(&:to_sym))
  end

  def set_user
    @user = User.find(params[:id])
  end

  def editing_authority
    return if is_adminer?
    return if @user.id == current_user.id
    redirect_to(root_url) and return 
  end

  def new_authority
    redirect_to root_path and return unless current_user.nil?
  end
end
