class TasksController < ApplicationController

  before_action :set_task, only: [:show, :edit, :update, :destroy]

     def index
      # @tasks = Task.all
      @q =Task.ransack(params[:q])
      @tasks = @q.result(distinct:true)
     end

      def show
      end

      def new
          @task = Task.new
      end

      def edit
      end

      def create
          @task = Task.new(task_params)
          if @task.save
            flash[:success] = "Task created successfully."
            redirect_to task_path(@task)
          else
           render :new, status: :unprocessable_entity
          end
      end

      def update
          if @task.update(task_params)
            flash[:success] = "Task updated successfully."
            redirect_to task_path(@task)
          else
            render :edit, status: :unprocessable_entity
          end
      end

      def destroy
        @task.destroy
        flash[:success] = "Task deleted successfully."
        redirect_to tasks_path
      end

      private

      def set_task
          @task = Task.find(params[:id])
      end

      def task_params
          params.require(:task).permit(:name, :description, :priority, :status, :duedate)
        end
end
