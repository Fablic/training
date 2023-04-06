class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.where(user_id: current_user.id).preload(:user, :labels)
    @tasks = @tasks.sort_by_keyword(search_params[:sort])
    @tasks = @tasks.search_by_status(search_params[:status]) if search_params[:status].present?
    @tasks = @tasks.search_by_keyword(search_params[:keyword]) if search_params[:keyword].present?
    @tasks = @tasks.page(search_params[:page])
    if search_params[:label_ids].present? && search_params[:label_ids] != ['']
      @tasks = @tasks.joined_search_by_label_ids(search_params[:label_ids]).distinct
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show; end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit; end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html do
          redirect_to task_url(@task), flash: { success: I18n.t('messages.create', model_name: @task.model_name.human) }
        end
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html do
          redirect_to task_url(@task), flash: { success: I18n.t('messages.update', model_name: @task.model_name.human) }
        end
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html do
        redirect_to tasks_url, flash: { success: I18n.t('messages.delete', model_name: @task.model_name.human) }
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
    raise ApplicationController::Forbidden if current_user.id != @task.user_id
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :expires_at).merge(user_id: current_user.id)
  end

  def search_params
    params[:sort] = Task.sort_params_checker(params[:sort])
    params.permit(:page, :keyword, :status, :sort, label_ids: [])
  end
end
