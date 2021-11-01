# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  around_action :skip_bullet, only: %i[destroy],if: -> { defined?(Bullet) }
  # GET /tasks or /tasks.json
  def index
    
    @dash_unfinished = Task.role_filtered(admin?, current_user.id).unfinished.count
    @dash_overdue = Task.role_filtered(admin?, current_user.id).overdue.count
    @dash_due_today = Task.role_filtered(admin?, current_user.id).due_today.count

    params[:q] = params[:q].presence || {}

    # always filter via user_id if not admin
    @q = Task.role_filtered(admin?, current_user.id)

    #run predefined searches 
    if !params[:dash_search].blank? && ['unfinised','overdue','due_today'].include?(params[:dash_search])
      @q = @q.send(params[:dash_search])
    end    

    #run other search 
    @q = @q.ransack(params[:q])

    #set default order by if not specified
    @q.sorts = 'created_at desc' if @q.sorts.empty?

    @tasks = @q.result.includes(:user,:labels).page(params[:page])
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
        format.html { redirect_to @task, notice: t('messages.created_success', target: Task.model_name.human()) }
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
        format.html { redirect_to @task, notice: t('messages.updated_success', target: Task.model_name.human()) }
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
      format.html { redirect_to tasks_url, notice: t('messages.deleted_success', target: Task.model_name.human()) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.role_filtered(admin?, current_user.id).find(params[:id])

    raise ActiveRecord::RecordNotFound if @task.nil?
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task)
      .permit(:name, :created_by, :created_at, :started_at, :finished_at, :description, :status, :priority, { label_ids: [] })
      .with_defaults(created_by: current_user.id)
  end
end
