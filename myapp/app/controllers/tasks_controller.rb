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
    @task = Task.new(posted_params)

    if @task.save
      flash[:success] = 'Successfully created'
      redirect_to root_path
    else
      flash.now[:danger] = 'falid to create'
      render :new
    end
  end

  # PATCH /tasks/:id(.:format) tasks#update
  # PUT   /tasks/:id(.:format) tasks#update
  def update
    @task = Task.find(params[:id])

    if @task.update(posted_params)
      flash[:success] = 'Successfully updated'
      redirect_to root_path
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
    if @task.destroy
      flash[:success] = 'Successfully deleted'
      redirect_to root_path
    else
      flash[:danger] = 'falid to delete'
      redirect root_path(@task)
    end
  end
  
  def posted_params
    params.fetch(:task, {}).permit(:title, :description)
  end

end
