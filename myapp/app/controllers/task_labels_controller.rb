# frozen_string_literal: true

class TaskLabelsController < ApplicationController
  def new
    @labels = Label.all
    @task_label = TaskLabel.new
    @task_id = task_label_params[:task_id]
    @attached_label_ids = set_task.labels.map(&:id)
  end

  def attach_labels
    if TaskLabel.transaction { laundering_labels }
      redirect_to task_url(task_label_params[:task_id]),
                  flash: { success: I18n.t('messages.attach', model_name: I18n.t('activerecord.models.label')) }
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def laundering_labels
    set_task.labels = Label.where(id: task_label_params[:label_ids])
  end

  def set_task
    Task.preload([:labels]).find(task_label_params[:task_id])
  end

  def task_label_params
    params.permit(:task_id, label_ids: [])
  end
end
