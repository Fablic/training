class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new

  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
  end
end
