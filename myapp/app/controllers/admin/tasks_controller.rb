# frozen_string_literal: true

module Admin
  class TasksController < ApplicationController # rubocop:disable Style/Documentation
    before_action :set_task, only: %i[show edit update destroy]

    def index
      user_id = params[:user_id]
      @tasks = Task.search(nil, nil, user_id, nil).order(created_at: :desc)
      @total_tasks_count = @tasks.count
      @user = User.find(user_id) if user_id
    end

    def show
      ## show
    end

    def edit
      ## edit
    end

    def update
      if @task.update(task_params)
        flash[:notice] = I18n.t('admin.tasks.update_success')
        redirect_to admin_task_path @task
      else
        flash.now[:alert] = I18n.t('admin.tasks.update_failure')
        render :edit
      end
    end

    def destroy
      if @task.destroy
        flash[:notice] = I18n.t('admin.tasks.delete_success')
      else
        flash[:alert] = I18n.t('admin.tasks.delete_failure')
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
