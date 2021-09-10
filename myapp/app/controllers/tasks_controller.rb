class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  def edit
    @task = Task.find(params[:id])
  end

  def new
  end

  def create

  end

  def show
    @task = Task.find(params[:id]) //いらない
  end

end
