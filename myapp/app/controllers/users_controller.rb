class UsersController < ApplicationController
  before_action :admin_user_checker
  before_action :set_user, only: %i[show edit update destroy]
  append_before_action :exist_other_admin_user?, only: %i[update destroy]

  # GET /users or /users.json
  def index
    @users = User.all.page(search_params[:page])
  end

  # GET /users/1 or /users/1.json
  def show
    @user_tasks = @user.tasks.preload(:task_labels, :labels)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html do
          redirect_to user_url(@user), flash: { success: I18n.t('messages.create', model_name: @user.model_name.human) }
        end
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html do
          redirect_to user_url(@user), flash: { success: I18n.t('messages.update', model_name: @user.model_name.human) }
        end
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html do
        redirect_to users_url, flash: { success: I18n.t('messages.delete', model_name: @user.model_name.human) }
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:id, :name, :email, :password, :role, :created_at, :updated_at)
  end

  def search_params
    params.permit(:page)
  end

  def exist_other_admin_user?
    return if @user.role_ordinary?
    return if params['user'].present? && params['user']['role'] == 'admin'

    admin_user_count = User.cnt_admin_user_except_current(@user.id)
    return if admin_user_count >= 1

    redirect_to users_path, flash: { danger: I18n.t("users.admin.#{action_name}.last_admin") }
  end

  def admin_user_checker
    raise Forbidden, self if current_user.role_ordinary?
  end
end
