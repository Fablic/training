# frozen_string_literal: true

class TaskLabelsController < ApplicationController
  def new
    @labels = Label.all
    @task_label = TaskLabel.new
    @task_id = task_label_params[:task_id]
    @attached_label_ids = Task.find(task_label_params['task_id']).labels.map(&:id)
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
    task = Task.includes([:labels]).find(task_label_params[:task_id])
    labels = Label.where(id: task_label_params[:label_ids])
    task.labels = labels
  end

  def task_label_params
    params.permit(:task_id, label_ids: [])
  end
end
