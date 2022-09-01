# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    if params && (params[:word].present? || params[:status].present?)
      @tasks = Task.search(params[:name], params[:status]).page(params[:page]).per(5)
    else
      @tasks = Task.all.page(params[:page]).per(5)
    end
  end

  def show
    @task = Task.find(params[:id])
    @user = User.find(@task.user_id)
  end

  def new
    @task = Task.new
    @users_name = users_name
  end

  def edit
    @task = Task.find(params[:id])
    @users_name = users_name
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_url, notice: "タスク「#{@task.title}」を登録しました。"
    else
      @users_name = users_name
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: "タスク「#{@task.title}」を更新しました。"
    else
      render :new
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_url, notice: "タスク「#{@task.title}」を削除しました。"
    else
      render :show
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :user_id)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def users_name
    User.all.map { |k| [k.name, k.id] }
  end
end
