# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :ensure_logged_in_admin

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

    def update # rubocop:disable Metrics/AbcSize
      @user = User.active.find(params[:id])

      if User.last_admin?(params[:id]) && user_params_on_update[:privilege] == 'user'
        return redirect_to admin_users_path, notice: I18n.t('dictionary.messages.last_admin_edit')
      end

      if @user.update(user_params_on_update)
        redirect_to admin_users_path, notice: I18n.t('dictionary.messages.edited_user')
      else
        @errors = @user.errors.full_messages
        @submit_label = I18n.t('dictionary.words.save_to_update')
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
        @errors = @user.errors.full_messages
        @submit_label = I18n.t('dictionary.words.save_to_create')
        render :new
      end
    end

    def destroy # rubocop:disable Metrics/AbcSize
      return redirect_to admin_users_path, notice: I18n.t('dictionary.messages.last_admin') if User.last_admin?(params[:id])

      if User.delete_user_and_tasks(params[:id])
        flash[:notice] = I18n.t('dictionary.messages.deleted_user')
        redirect_to admin_users_path
      else
        redirect_to admin_users_path, notice: I18n.t('dictionary.messages.deleted_user_task_failed')
      end
    end

    def user_params_on_create
      params.require(:user).permit(:name, :password, :privilege)
    end

    def user_params_on_update
      params.require(:user).permit(:password, :privilege)
    end
  end
end
