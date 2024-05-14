class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    if not is_valid(task_params['title'])
      redirect_to new_task_path, notice: 'Cannot create a task with empty title.'
    else
      @task = Task.new(task_params)
      if @task.save
        redirect_to @task, notice: 'Task created.'
      else
        render :new
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    if not is_valid(@task['title'])
      redirect_to edit_task_path(@task['id']), notice: 'Cannot create a task with empty title.'
    else
      if @task.update(task_params)
        redirect_to @task, notice: 'Task updated.'
      end
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Task deleted.'
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description)
    end

    def is_valid(text)
      puts 'OOOOOOOOOOOOOOO      ' + text
      return not(text == '' or text == nil)
    end
end
