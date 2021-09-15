class TasksController < ApplicationController
  def index
    @tasks = Task.where(deleted: 0)
  end

  def new
  end

  def edit
    id = params[:id]
    @task = Task.find_by(id: id, deleted:0)
  end

  def update
     @task = Task.find(params[:id])
     @task.update(name: params[:task][:name], description: params[:task][:description], start_at_date: params[:task][:start_at_date], start_at_hour: params[:task][:start_at_hour], start_at_minute: params[:task][:start_at_minute], due_date_at_date: params[:task][:due_date_at_date], due_date_at_hour: params[:task][:due_date_at_hour], due_date_at_minute: params[:task][:due_date_at_minute])
    redirect_to tasks_path, notice: 'タスクが更新されました'
  end

  def show
    id = params[:id]
    @task = Task.find_by(id: id, deleted:0)
  end

  def create
    @task = Task.new(name: params[:name], description: params[:description], start_at: params[:start_at_date] << ' ' << params[:start_at_hour] << ':' << params[:start_at_minute], due_date_at: params[:due_date_at_date] << ' ' << params[:due_date_at_hour] << ':' << params[:due_date_at_minute])
    @task.save
    redirect_to tasks_path, notice: 'タスクが作成されました'
  end

  def destroy
    @task = Task.find(params[:id])
    @task.update(deleted: 1)
    redirect_to tasks_path, notice: 'タスクが削除されました'
  end

end
