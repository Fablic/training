class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def create
  end

  def new
  end

  def edit
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
  end

  def destroy
  end
end
