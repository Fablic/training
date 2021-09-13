class TasksController < ApplicationController

  # GET /tasks(.:format)
  def index
    @tasks = Task.all
  end

  # GET /tasks/:id/edit(.:format)
  def edit
    @task = Task.find(params[:id])
  end

  # GET /tasks/new(.:format) 
  def new
    @task = Task.new
  end

  # POST /tasks(.:format)
  def create
    task_params = params.fetch(:task, {}).permit(:title, :description)
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = 'Successfully created'
      redirect_to root_path, status: :created
    else
      flash.now[:danger] = 'falid to create'
      render :new, status: :internal_server_error
    end
  end

  # PATCH /tasks/:id(.:format) tasks#update
  # PUT   /tasks/:id(.:format) tasks#update
  def update
    @task = Task.find(params[:id])
    task_params = params.fetch(:task, {}).permit(:title, :description)

    if @task.update(task_params)
      flash[:success] = 'Successfully updated'
      redirect_to root_path, status: :ok
    else
      flash[:danger] = 'falid to update'
      redirect_to edit_task_path(@task)
    end
  end

  # GET /tasks/:id(.:format)  
  def show
    @task = Task.find(params[:id])
  end

  # DELETE /tasks/:id(.:format)
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
  end

end
