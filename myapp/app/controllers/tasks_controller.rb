# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def create
    @task = Task.new(params.require(:task).permit(:name, :description))

    if @task.save
      flash[:success] = 'Added new task'
      redirect_to @task
    else
      flash[:danger] = 'failed'
      render :new
    end
  end

  def new
    @task = Task.new()
  end

  def edit
    @task = Task.find(params[:id])
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(params.require(:task).permit(:name, :description))
      flash[:success] = 'Edit success'
      redirect_to @task
    else
      flash[:danger] = 'Edit failed'
      render :edit
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    flash[:success] = 'delete success'
    redirect_to tasks_path
  end
end
