# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task, only: %i[update destroy]

  def create # rubocop:disable Metrics/AbcSize
    task = Task.new(request_params)
    if task.save
      redirect_to project_url(id: params[:project_id]), alert: I18n.t('flash.success_create', model_name: 'task')
    else
      flash[:alert] = I18n.t('flash.failed_create', model_name: 'task')
      redirect_to project_url(id: params[:project_id]), notice: task.errors.full_messages

    end
  end

  def update # rubocop:disable Metrics/AbcSize
    if @find_task.update(request_params)
      redirect_to project_url(id: @find_task.group.project.id), alert: I18n.t('flash.success_updated', model_name: 'task')
    else
      flash[:alert] = I18n.t('flash.failed_update', model_name: 'task')
      redirect_to project_url(id: @find_task.group.project.id), alert: I18n.t('flash.failed_update', model_name: 'task')
    end
  end

  def destroy
    project_id = @find_task.group.project.id
    @find_task.destroy
    redirect_to project_url(id: project_id), alert: I18n.t('flash.success_destroy', model_name: 'task')
  end

  private

  def find_task
    @find_task ||= Task.find_by!(id: params[:id])
  end

  def request_params
    params.require(:task).permit(:name, :description, :priority, :group_id, :end_period_at, :creator_name, :assignee_name)
  end
end
