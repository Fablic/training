# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :ensure_logged_in

  def index
    @users = User.active.order('name asc').page(params[:page]).per(10).includes(:tasks)
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

    if @user.update(user_params_on_update)
      redirect_to admin_users_path, notice: I18n.t('dictionary.messages.edited_user')
    else
      render :edit
    end
  end

  def show
    @user = User.active.find_by(id: params[:id])
    @tasks = Task.available(params[:id]).order('created_at desc')
    redirect_to admin_users_path if @user.nil?
  end

  def create
    @user = User.new(user_params_on_create)

    if @user.save
      redirect_to admin_users_path, notice: I18n.t('dictionary.messages.created_user')
    else
      render :new
    end
  end

  def destroy # rubocop:disable Metrics/AbcSize
    @tasks = Task.available(params[:id])

    ActiveRecord::Base.transaction do

      if @tasks.update(deleted: 1)
        @user = User.active.find_by(id: params[:id])
        if @user.update(deleted: 1)
          flash[:notice] = I18n.t('dictionary.messages.deleted_user')
        else
          redirect_to admin_users_path, notice: I18n.t('dictionary.messages.deleted_user_failed')
          raise ActiveRecord::Rollback
        end
      else
        raise ActiveRecord::Rollback
        flash[:notice] = I18n.t('dictionary.messages.deleted_user_task_failed')
      end
    end

    redirect_to admin_users_path
  end

  def user_params_on_create
    params.require(:user).permit(:name, :password, :privilege)
  end

  def user_params_on_update
    params.require(:user).permit(:password, :privilege)
  end
end
