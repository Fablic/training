# frozen_string_literal: true

class UsersController < ApplicationController
  helper_method :sort_direction

  before_action :logged_in_user
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @search_params = user_search_params
    @users = User.search_condition(@search_params)
    @users = @users.order("#{sort_column} #{sort_direction}")
    @users = @users.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(post_params)

    if @user.save
      flash[:notice] = t('users.flash.complete_user_registration')
      redirect_to users_path
    else
      render :new
    end
  end

  def update
    if @user.update(post_params)
      flash[:notice] = t('users.flash.complete_user_edit')
      redirect_to users_path
    else
      render :edit
    end
  end

  def destroy
    if User.where(is_admin: true).count == 1
      flash[:alert] = t('users.flash.only_one_admin')
      redirect_to users_path
      return
    end

    if @user.destroy
      flash[:notice] = t('users.flash.complete_user_destroy')
    else
      flash[:alert] = t('users.flash.error_user_destroy')
    end
    redirect_to users_path
  end

  private

  def user_search_params
    params.fetch(:search, {}).permit(:name_cont, :login_id_eq)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def post_params
    params.require(:user)
      .permit(:name, :login_id, :password, :password_confirm, :is_admin)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) && (params[:direction] == 'asc') ? 'desc' : 'asc'
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
