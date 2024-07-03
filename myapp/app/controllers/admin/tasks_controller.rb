# frozen_string_literal: true

module Admin
  class TasksController < ApplicationController # rubocop:disable Style/Documentation
    before_action :set_task, only: %i[show edit update destroy]

    def index
      user_id = params[:user_id]
      unless user_id.nil?
        @user = User.find(user_id)
      end
      @tasks = Task.search(nil, nil, params[:user_id]).order(created_at: :desc)
      @total_tasks_count = @tasks.count
    end

    def show
      ## show
    end

    def edit
      ## edit
    end

    def update
      if @task.update(task_params)
        flash[:notice] = I18n.t('tasks.update_success')
        redirect_to admin_task_path @task
      else
        flash.now[:alert] = I18n.t('tasks.update_failure')
        render :edit
      end
    end

    def destroy
      if @task.delete
        flash[:notice] = I18n.t('tasks.delete_success')
      else
        flash[:alert] = I18n.t('tasks.delete_failure')
      end
      redirect_to admin_tasks_path
    end

    private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :status, :priority, :due_date)
    end
  end
end
