# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user

  def index
    @users = User.active.order("name asc").page(params[:page]).per(10)
  end

  def new
    @user = User.new
    @submit_label = I18n.t('dictionary.words.save_to_create')
  end

  def edit
    @user = User.active.find_by(id: params[:id])
    @submit_label = I18n.t('dictionary.words.save_to_update')

    redirect_to admin_users_path if @user.nil?
  end

  def update
    @user = User.active.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_users_path, notice: I18n.t('dictionary.messages.edited_user')
    else
      render :edit
    end
  end

  def show
    id = params[:id]
    @user = User.active.find_by(id: id)

    redirect_to admin_users_path if @user.nil?
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: I18n.t('dictionary.messages.created_user')
    else
      render :new
    end
  end

  def destroy
    @tasks = Task.find_by(user_id: params[:id])

    unless @tasks.update(deleted: 1)
      redirect_to admin_users_path, notice: I18n.t('dictionary.messages.deleted_user_task_failed')
    end

    @user = User.active.find_by(id: params[:id])
    flash[:notice] = if @user.update(deleted: 1)
                       I18n.t('dictionary.messages.deleted_user')
                     else
                       I18n.t('dictionary.messages.deleted_user_failed')
                     end

    redirect_to admin_users_path
  end

  def user_params
    params.require(:user).permit(:name, :password, :privilege)
  end
end