class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.includes(:user)
                 .search_title(params[:title])
                 .search_status(params[:status])
                 .default_order.page(params[:page]).per(6)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
    @edit_mode = false
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @edit_mode = true
  end

  # GET /tasks/1/edit
  def edit
    @edit_mode = true
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = I18n.t('flash.common.success', model: I18n.t('actions.create'))
      redirect_to tasks_url
    else
      @edit_mode = true
      flash.now[:alert] = I18n.t('flash.common.failure', model: I18n.t('actions.create'))
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    if @task.update(task_params)
      flash[:notice] = I18n.t('flash.common.success', model: I18n.t('actions.update'))
      redirect_to tasks_url
    else
      @edit_mode = true
      flash.now[:alert] = I18n.t('flash.common.failure', model: I18n.t('actions.update'))
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    flash[:notice] = I18n.t('flash.common.success', model: I18n.t('actions.destroy'))
    redirect_to tasks_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(
        :title,
        :user_id,
        :start_date,
        :due_date,
        :priority,
        :status,
        :details
      )
    end
end
