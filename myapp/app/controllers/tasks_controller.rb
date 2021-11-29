# frozen_string_literal: true

class TasksController < ApplicationController
  PAGE_LIMIT = 5

  helper_method :sort_column, :sort_direction, :status_selected

  before_action :set_task, only: %i[show edit update destroy]

  def index
    @task = Task.new
    @tasks = Task.search(params).page(params[:page]).per(PAGE_LIMIT).order("#{sort_column} #{sort_direction}")
    # @tasks = Kaminari.paginate_array(@tasks)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: I18n.t('pages.tasks.flash.registered') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: I18n.t('pages.tasks.flash.edited') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: I18n.t('pages.tasks.flash.destroyed') }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.fetch(:task).permit(:title, :description, :priority, :status, :expires_at)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'expires_at'
  end

  def status_selected
    Task.statuses.keys.include?(params[:status]) ? params[:status] : ''
  end
end
