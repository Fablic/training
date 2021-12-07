# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :ensure_logged_in

  def index
    @tasks = Task.available(current_user.id).order("#{sort_column} #{sort_direction}").includes(:task_labels, :labels).page(params[:page]).per(10)
  end

  def new
    @task = Task.new
    @label_names = []
  end

  def create
    post_params = task_params
    post_params['user_id'] = current_user.id
    @task = Task.new(post_params)
    @label_names = task_labels[:labels].split(',')
    labels = build_labels(@label_names)

    return render :new unless validate_all(@task, labels)

    return save_success if Task.save_all(@task, labels)

    save_fault(:new)
  end

  def edit
    @task = Task.available(current_user.id).find_by(id: params[:id])

    return render404 if @task.nil?

    @label_names = @task.labels.pluck(:name)
  end

  def update
    @task = current_task
    @task.attributes = task_params
    @label_names = task_labels[:labels].split(',')
    labels = build_labels(@label_names)

    return render :edit unless validate_all(@task, labels)

    return save_success if Task.save_all(@task, labels)

    save_fault(:edit)
  end

  def show
    id = params[:id]
    @task = Task.available(current_user.id).includes(:labels).find_by(id: id)

    render404 if @task.nil?
  end

  def destroy
    @task = Task.available(current_user.id).find(params[:id])
    flash[:notice] = if @task.update(deleted: 1)
                       I18n.t('dictionary.messages.deleted_task')
                     else
                       I18n.t('dictionary.messages.deleted_task_failed')
                     end

    redirect_to tasks_path
  end

  def search
    return redirect_to tasks_path if params[:keyword].blank? && params[:status].blank?

    @tasks = searched_tasks
    @keyword = params[:keyword]
    @status = params[:status]

    render :index
  end

  private

  def searched_tasks
    Task.search(params[:keyword], params[:status], current_user.id, "#{sort_column} #{sort_direction}").page(params[:page]).per(10)
  end

  def task_params
    params.require(:task).permit(:name, :description, :status, :start_at, :due_date_at)
  end

  def task_labels
    params.require(:task).permit(:labels)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'tasks.created_at'
  end

  def build_labels(label_names)
    label_names.map do |label_name|
      Label.find_or_initialize_by(name: label_name)
    end
  end

  def current_task
    Task.available(current_user.id).find_by(id: params[:id])
  end

  def validate_all(task, labels)
    invalid_labels = labels.select(&:invalid?)

    return true if invalid_labels.blank? && task.valid?

    @errors = build_errors(task, invalid_labels)
    false
  end

  def build_errors(task, invalid_labels)
    errors = invalid_labels.each_with_object([]) do |label, loop_errors|
      loop_errors.concat(label.errors.full_messages)
    end.tap do |loop_errors|
      loop_errors.concat(task.errors.full_messages) if task.invalid?
    end

    errors.uniq
  end

  def save_success
    redirect_to tasks_path, notice: I18n.t('dictionary.messages.edited_task')
  end

  def save_fault(template)
    flash.now[:notice] = I18n.t('dictionary.messages.failed_save_task')
    render template
  end
end
