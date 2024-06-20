class UsersController < ApplicationController # rubocop:disable Style/Documentation
  before_action :set_user, only: %i[show edit update destroy]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @edit_mode = false
  end

  # GET /users/new
  def new
    @user = User.new
    @edit_mode = true
  end

  # GET /users/1/edit
  def edit
    @edit_mode = true
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = I18n.t('flash.common.success', model: I18n.t('actions.create'))
      redirect_to users_url
    else
      @edit_mode = true
      flash.now[:alert] = I18n.t('flash.common.failure', model: I18n.t('actions.create'))
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if @user.update(user_params)
      flash[:notice] = I18n.t('flash.common.success', model: I18n.t('actions.update'))
      redirect_to users_url
    else
      @edit_mode = true
      flash.now[:alert] = I18n.t('flash.common.failure', model: I18n.t('actions.update'))
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    flash[:notice] = I18n.t('flash.common.success', model: I18n.t('actions.destroy'))
    redirect_to users_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :password, :role)
  end
end
