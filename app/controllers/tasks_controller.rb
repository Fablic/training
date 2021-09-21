class TasksController < ApplicationController
  before_action :logged_in_user
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks
  def index
    @tasks = Task.all
    @tasks = @tasks.search_by_name(params[:name]) if params[:name].presence
    @tasks = @tasks.search_by_status(params[:status]) if params[:status].presence
  end

  # GET /tasks/1
  def show; end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit; end

  # POST /tasks
  def create
    @task = Task.new(task_params.merge(user_id: current_user.id))

    if @task.save
      redirect_to root_path, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to root_path, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    if @task.destroy
      redirect_to @task, notice: "Task was successfully deleted."
    else
      redirect_to @task, notice: "Failed to delete."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.fetch(:task, {}).permit(:name, :description, :priority, :status)
    end
end
