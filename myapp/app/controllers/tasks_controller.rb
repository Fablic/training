# frozen_string_literal: true

# task management
class TasksController < ApplicationController
  def index
    @tasks = Task.search(params[:search])
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(post_params)
    flash[:notice] = if @task.save
<<<<<<< HEAD
                       t('tasks.flash.complete_task_registration')
                     else
                       t('tasks.flash.error_task_registration')
=======
                       'The task registration is complete.'
                     else
                       'The task update is error.'
>>>>>>> origin/ichinoseken
                     end
    redirect_to root_path
  end

  def update
    @task = Task.find(params[:id])
    flash[:notice] = if @task.update(post_params)
<<<<<<< HEAD
                       t('tasks.flash.complete_task_edit')
                     else
                       t('tasks.flash.error_task_edit')
=======
                       'The task update is complete.'
                     else
                       'The task update is error.'
>>>>>>> origin/ichinoseken
                     end
    redirect_to root_path
  end

  def destroy
    @task = Task.find(params[:id])
    flash[:notice] = if @task.destroy
<<<<<<< HEAD
                       t('tasks.flash.complete_task_destroy')
                     else
                       t('tasks.flash.error_task_destroy')
=======
                       'The task delete is complete.'
                     else
                       'The task delete is error.'
>>>>>>> origin/ichinoseken
                     end
    redirect_to root_path
  end

  private

  def post_params
    params.require(:task).permit(
      :task_name, :description, :status,
      :priority, :label, :start_date, :end_date)
  end
end
