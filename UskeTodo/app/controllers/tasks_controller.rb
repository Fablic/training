class TasksController < ApplicationController
  def index
      @tasks = Post.all
  end

  def new
      @tasks = Post.new
  end
    
  def create
      @tasks = Post.new(tasks_params)
      @tasks.save
        redirect_to tasks_path
  end

  def edit
      @tasks = Post.find(params[:id])
  end

  def update
      @tasks = Post.find(params[:id])
      if @task.update(task_params)
        redirect_to tasks_path
      else
        render 'edit'
      end
  end

  def show
      @tasks = Post.find(params[:id])
  end
    
  def destroy
      @tasks = Post.find(params[:id])
      @tasks.destroy
        redirect_to tasks_path
  end  
    
    private
  def tasks_params
      params.permit(:id)
  end

    
end

