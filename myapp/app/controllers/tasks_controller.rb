# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  # GET /tasks(.:format)
  def index
    @search = Task.ransack(params[:q])
    @search.sorts = 'created_at desc' if @search.sorts.empty?
    @tasks = @search.result
  end

  # GET /tasks/:id/edit(.:format)
  def edit
  end

  # GET /tasks/new(.:format)
  def new
    @task = Task.new
  end

  # POST /tasks(.:format)
  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = 'Successfully created'
      redirect_to root_path
    else
      render :new
    end
  end

  # PATCH /tasks/:id(.:format) tasks#update
  # PUT   /tasks/:id(.:format) tasks#update
  def update
    if @task.update(task_params)
      flash[:success] = 'Successfully updated'
      redirect_to root_path
    else
      render :edit
    end
  end

  # GET /tasks/:id(.:format)
  def show
  end

  # DELETE /tasks/:id(.:format)
  def destroy
    if @task.update(deleted: 1)
      flash[:success] = 'Successfully deleted'
      redirect_to root_path
    else
      flash[:danger] = 'falid to delete'
      redirect root_path(@task)
    end
  end

  private

  def set_task
    @task = Task.find_by(id: params[:id], deleted: 0)
  end

  def task_params
    params.fetch(:task, {}).permit(:title, :description, :due_date, :status)
  end
end
