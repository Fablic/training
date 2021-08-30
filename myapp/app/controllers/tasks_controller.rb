class TasksController < ApplicationController
  def index
    @tasks = Task.order('created_at desc')
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = I18n.t('flash.new_success')
      redirect_to @task
    else
      flash[:danger] = I18n.t('flash.new_danger')
      flash[:validation_error] = @task.errors.full_messages
      redirect_to new_task_path
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = I18n.t('flash.updated_success')
      redirect_to @task
    else
      flash[:danger] = I18n.t('flash.updated_danger')
      flash[:validation_error] = @task.errors.full_messages
      redirect_to edit_task_path(@task)
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:success] = I18n.t('flash.destroy')
    redirect_to tasks_path
  end
end

def task_params
  params.require(:task).permit(:title, :content)
end
