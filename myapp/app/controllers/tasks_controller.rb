class TasksController < ApplicationController
  before_action :set_query, only: [:index]

  # GET /tasks(.:format)
  def index
    @tasks = @q.result
    @tasks = @tasks.where(deleted: 0).order('created_at desc')
  end

  # GET /tasks/:id/edit(.:format)
  def edit
    @task = Task.find_by(id: params[:id], deleted: 0)
  end

  # GET /tasks/new(.:format)
  def new
    @task = Task.new
  end

  # POST /tasks(.:format)
  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = 'Successfully created'
      redirect_to root_path
    else
      render :new
    end
  end

  # PATCH /tasks/:id(.:format) tasks#update
  # PUT   /tasks/:id(.:format) tasks#update
  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'Successfully updated'
      redirect_to root_path
    else
      render :edit
    end
  end

  # GET /tasks/:id(.:format)
  def show
    @task = Task.find(params[:id])
  end

  # DELETE /tasks/:id(.:format)
  def destroy
    @task = Task.find(params[:id])
    if @task.update(deleted: 1)
      flash[:success] = 'Successfully deleted'
      redirect_to root_path
    else
      flash[:danger] = 'falid to delete'
      redirect root_path(@task)
    end
  end

  private

  def task_params
    params.fetch(:task, {}).permit(:title, :description)
  end

  def set_query
    @q = Task.ransack(params[:q])
  end
end
