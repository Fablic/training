class TasksController < ApplicationController
  include ErrorValidationExtractor

  PER_PAGE = 10

  def index
    @params = params.permit(:name, :status, :label).to_hash.symbolize_keys!.select { |_k, v| v.presence }
    @tasks = current_user!.tasks.includes(:labels).order(:id).page(params[:page]).per(PER_PAGE)
    @tasks = @tasks.name_with(@params[:name]) if @params[:name]
    @tasks = @tasks.joins(task_label_attachments: :label).merge(Label.where(name: @params[:label])) if @params[:label]
    @tasks = @tasks.where(status: @params[:status]) if @params[:status]
    @labels = current_user!.labels
  end

  def new
    @task = Task.new(user: current_user!, name: '', description: '', priority: :normal, status: :waiting)
    @labels = current_user!.labels
  end

  def edit
    @task = current_user!.tasks.find(params.require(:id))
    @labels = current_user!.labels
  end

  def create
    task = Task.new(params.require(:task).permit(:name, :description, :due_date, :priority, :status))
    task.user = current_user!
    save!(task)
    redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.added') }
  rescue ActiveRecord::RecordInvalid => error
    redirect_to root_path, flash: { error: error_message_from(error.record) }
  end

  def update
    task = current_user!.tasks.find(params.require(:id))
    save!(task)
    redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.edited') }
  rescue ActiveRecord::RecordInvalid => error
    redirect_to root_path, flash: { error: error_message_from(error.record) }
  end

  def destroy
    task = current_user!.tasks.find(params.require(:id))
    if task.destroy
      redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.deleted') }
    else
      redirect_to root_path, flash: { error: error_message_from(task) }
    end
  end

  private

  def save!(task)
    now = Time.current
    label_ids = params.require(:task).permit(labels: []).fetch(:labels, [])
    permitted = params.require(:task).permit(:name, :description, :due_date, :priority, :status)
    task.assign_attributes(permitted)

    ApplicationRecord.transaction do
      task.save!

      TaskLabelAttachment.where(task: task).destroy_all
      attachments = label_ids.map do |label_id|
        TaskLabelAttachment.new(label_id: label_id, task: task, created_at: now, updated_at: now).then do |a|
          a.validate!
          a.attributes
        end
      end
      TaskLabelAttachment.insert_all!(attachments) if attachments.present?
    end
  end
end
