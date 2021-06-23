class TasksController < ApplicationController

  before_action :find_task, only: %i(edit update show destroy)

  def index
    @request_order = params[:order]&.to_sym.eql?(:desc) ? :desc : :asc
    @tasks = Task.order(created_at: @request_order)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = I18n.t('tasks.flash.success.create')
      redirect_to root_path
    else
      flash.now[:error] = I18n.t('tasks.flash.error.create')
      render :new
    end
  end

  def update
    if @task.update(task_params)

      flash[:success] = I18n.t('tasks.flash.success.update')
      redirect_to task_path(@task)
    else
      flash.now[:error] = I18n.t('tasks.flash.error.update')
      render :edit
    end
  end

  def destroy
    @task.delete

    flash[:success] = I18n.t('tasks.flash.success.destroy')
    redirect_to root_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description)
  end

  def find_task
    @task = Task.find_by(id: params[:id])
  end
end
