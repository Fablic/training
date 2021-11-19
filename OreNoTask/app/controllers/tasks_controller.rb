# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :ensure_logged_in

  def index
    @tasks = Task.available(current_user.id).order("#{sort_column} #{sort_direction}").includes(:task_labels, :labels).page(params[:page]).per(10)
  end

  def new
    @task = Task.new
    @label_names = ''
    @submit_label = I18n.t('dictionary.words.save_to_create')
  end

  def edit
    @task = Task.available(current_user.id).find_by(id: params[:id])
    @submit_label = I18n.t('dictionary.words.save_to_update')

    @label_ids = TaskLabel.where(task_id: params[:id]).pluck(:label_id)
    @label_names = Label.where(id: @label_ids).pluck(:name).join(',')

    render404 if @task.nil?
  end

  def update # rubocop:disable Metrics/AbcSize
    post_params = task_params
    post_labels = task_labels[:labels]

    @task = Task.available(current_user.id).find_by(id: params[:id])
    @task.attributes = post_params
    errors = validate_task_and_labels(@task, post_labels)

    if errors.present?
      @submit_label = I18n.t('dictionary.words.save_to_update')
      @label_names = post_labels
      @errors = errors
      return render :edit
    end

    if Task.save_task_and_label(current_user.id, params[:id], post_params, post_labels)
      redirect_to tasks_path, notice: I18n.t('dictionary.messages.edited_task')
    else
      @submit_label = I18n.t('dictionary.words.save_to_update')
      @label_names = post_labels
      flash[:notice] = I18n.t('dictionary.messages.failed_save_task')
      render :edit
    end
  end

  def show
    id = params[:id]
    @task = Task.available(current_user.id).includes(:labels).find_by(id: id)

    render404 if @task.nil?
  end

  def create # rubocop:disable Metrics/AbcSize
    post_params = task_params
    post_labels = task_labels[:labels]

    @task = Task.new(post_params)

    errors = validate_task_and_labels(@task, post_labels)

    if errors.present?
      @submit_label = I18n.t('dictionary.words.save_to_create')
      @label_names = post_labels
      @errors = errors
      return render :new
    end

    if Task.save_task_and_label(current_user.id, nil, post_params, post_labels)
      redirect_to tasks_path, notice: I18n.t('dictionary.messages.created_task')
    else
      @submit_label = I18n.t('dictionary.words.save_to_create')
      @label_names = post_labels
      flash[:notice] = I18n.t('dictionary.messages.failed_save_task')
      render :new
    end
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

  def search # rubocop:disable Metrics/AbcSize
    return redirect_to tasks_path if params[:keyword].blank? && params[:status].blank?

    @tasks = Task.search(params[:keyword], params[:status], current_user.id, "#{sort_column} #{sort_direction}").page(params[:page]).per(10)
    @keyword = params[:keyword]
    @status = params[:status]

    render :index
  end

  private

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

  def validate_task_and_labels(task, labels)
    errors = []
    errors += task.errors.full_messages unless task.valid?

    labels.split(',').each do |label_name|
      @label = Label.new(name: label_name)
      errors += @label.errors.full_messages unless @label.valid?
    end
    errors.uniq
  end
end
