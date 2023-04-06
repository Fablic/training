class TaskLabelsController < ApplicationController
  def new
    @labels = Label.all
    @task_label = TaskLabel.new
    @task_id = task_label_params[:task_id]
    @attached_label_ids = set_task.labels.map(&:id)
  end

  def attach_labels
    if TaskLabel.transaction { attach_labels_exec }
      format.html do
        redirect_to task_url(task_label_params[:task_id]), flash: { success: I18n.t('messages.attach', model_name: @task_label.model_name.human) }
      end
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @task_label.errors, status: :unprocessable_entity }
    end
  end

  private

  def attach_labels_exec
    set_task.labels = Label.where(id: task_label_params[:label_ids])
  end

  def set_task
    Task.preload([:labels]).find(task_label_params[:task_id])
  end

  def task_label_params
    params.permit(:task_id, label_ids: [])
  end
end
