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
    @task = Task.create(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_url, notice: "タスク「#{@task.title}」を登録しました。" }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.update(task_params)
    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_url, notice: "タスク「#{@task.title}」を更新しました。" }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @task = Task.find(params[:id])
    respond_to do |format|
      if @task.destroy
        format.html { redirect_to tasks_url, notice: "タスク「#{@task.title}」を削除しました。" }
      else
        format.html { render :show }
      end
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description)
  end
end
