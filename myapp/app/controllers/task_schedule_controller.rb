# frozen_string_literal: true

class TaskScheduleController < ApplicationController
  def index
    @tasks = if params[:desc]
               Task.all.desc
             elsif params[:asc]
               Task.all.asc
             else
               Task.all.desc
             end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = t('.success')
      redirect_to action: 'index'
    else
      flash.now[:danger] = t('.danger')
      render 'task_schedule/edit'
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = t('.success')
      redirect_to action: 'index'
    else
      flash.now[:danger] = t('.danger')
      render 'task_schedule/new'
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def destroy
    if Task.find(params[:id]).destroy
      flash[:success] = t('.success')
      redirect_to action: 'index'
    else
      flash.now[:danger] = t('.danger')
      render 'task_schedule/index'
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :body)
  end
end
