class TaskController < ApplicationController
  def index
    @tasks = Task.where(deleted: 0)
  end

  def new
  end

  def edit
  end

  def detail
    id = params[:id]
    @task = Task.find_by(id: id, deleted:0)
  end

  def delete
  end
end
