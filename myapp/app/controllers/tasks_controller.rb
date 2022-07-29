# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]

  def index # rubocop:disable Metrics/AbcSize
    user_id = session[:user_id]
    @tasks = Task.search(user_id: user_id, status: params[:status], keyword: params[:keyword], sort: params[:sort], direction: params[:direction]).page(params[:page])
    @tasks = @tasks.includes(:labels, :task_labels)
    @tasks = @tasks.where(labels: { id: params[:label_id] }) if params[:label_id].present?
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
    @task = current_user.tasks.new(task_params)

    if @task.save
      flash[:success] = I18n.t('tasks.flash.create.success')
      redirect_to @task
    else
      flash.now[:danger] = I18n.t('tasks.flash.create.error')
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = I18n.t('tasks.flash.update.success')
      redirect_to @task
    else
      flash.now[:danger] = I18n.t('tasks.flash.update.error')
      render :edit
    end
  end

  def destroy
    if Task.find(params[:id]).destroy
      flash[:success] = I18n.t('tasks.flash.destroy.success')
    else
      flash[:danger] = I18n.t('tasks.flash.destroy.error')
    end
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :priority, :status, :limit, { label_ids: [] })
  end
end
