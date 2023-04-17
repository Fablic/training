class TasksController < ApplicationController
   before_action :set_task, only: [:edit, :update]
   def index
      @task = Task.all
   end

   def new
      @task = Task.new
   end

   def create
      @task = Task.new(task_params)
      if @task.valid?
         @task.save
         redirect_to tasks_path
      else
         render :new
      end
   end

   def edit
   end

   def update
      if @task.update(task_params)
         redirect_to tasks_path
      else
         render :edit
      end
   end

   private
   def set_task
      @task = Task.find(params[:id])
   end

   def task_params
      params.require(:task).permit(:title, :content)
   end

end
