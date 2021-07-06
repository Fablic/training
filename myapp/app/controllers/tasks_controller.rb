# frozen_string_literal: true
require 'pp'

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :set_user, only: %i[create index new]
  before_action :logged_in_user

  # GET /tasks or /tasks.json
  # All tasks
  def index
    @q = Task.ransack(params[:q])
    @tasks = @q.result
    unless admin_logged_in?
      @tasks = @tasks.where(assignee: current_user.id)
    end
    @tasks = @tasks.order('created_at desc').page(params[:page]).per(5)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = current_user.task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = current_user.task.new(task_params)
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:name, :desc, :status, :label, :priority, :due_date, :assignee)
  end

  def set_user
    @user = current_user
  end
end
