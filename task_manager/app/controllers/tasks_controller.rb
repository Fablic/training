class TasksController < ApplicationController
    def index
        @tasks = Task.all
    end
  
    def show
        @task = Task.find(params[:id])
    end
  
    def new
        @task = Task.new
    end
  
    def create
        @task = Task.new(task_params)

        if @task.save
          flash[:success] = 'タスクが投稿されました'
          redirect_to @task
        else
          flash[:danger] = 'タスクが投稿されません'
          render :new
        end
    end
  
    def edit
        @task = Task.find(params[:id])
    end
  
    def update
    end
  
    def destroy
    end  

    private

    def task_params
        params.require(:task).permit(:name,:due_at,:priority,:progress)
    end
end
