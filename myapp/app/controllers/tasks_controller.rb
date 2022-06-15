# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.all
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
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = 'Added new task' # TODO: I18nLocaleTexts error Step9で実装
      redirect_to @task
    else
      flash[:error] = 'failed' # TODO: I18nLocaleTexts error Step9で実装
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'Edit success' # TODO: I18nLocaleTexts error Step9で実装
      redirect_to @task
    else
      flash[:error] = 'Edit failed' # TODO: I18nLocaleTexts error Step9で実装
      render :edit
    end
  end

  def destroy
    if Task.find(params[:id]).destroy
      flash[:success] = 'delete success' # TODO: I18nLocaleTexts error Step9で実装
    else
      flash[:error] = 'Delete failed' # TODO: I18nLocaleTexts error Step9で実装
    end
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end
end
