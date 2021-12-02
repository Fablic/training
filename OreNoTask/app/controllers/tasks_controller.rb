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

  def edit
    @task = Task.available(current_user.id).find_by(id: params[:id])

    return render404 if @task.nil?

    @label_names = @task.labels.pluck(:name)
  end

  def update # rubocop:disable Metrics/AbcSize
    @label_names = task_labels[:labels].split(',')

    @task = Task.available(current_user.id).find_by(id: params[:id])
    @task.attributes = task_params

    ActiveRecord::Base.transaction do
      @task.labels.destroy_all
      return redirect_to tasks_path, notice: I18n.t('dictionary.messages.edited_task') if save_with_labels(@task, @label_names)

      raise ActiveRecord::Rollback
    end

    @errors = validate_with_labels(@task, @label_names)

    flash.now[:notice] = I18n.t('dictionary.messages.failed_save_task') if @errors.blank?
    render :edit
  end

  def show
    id = params[:id]
    @task = Task.available(current_user.id).includes(:labels).find_by(id: id)

    render404 if @task.nil?
  end

  def create # rubocop:disable Metrics/AbcSize
    post_params = task_params
    @label_names = task_labels[:labels].split(',')

    post_params['user_id'] = current_user.id
    @task = Task.new(post_params)

    if save_with_labels(@task, @label_names)
      redirect_to tasks_path, notice: I18n.t('dictionary.messages.created_task')
    else
      @errors = validate_with_labels(@task, @label_names)
      flash.now[:notice] = I18n.t('dictionary.messages.failed_save_task') if @errors.blank?
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

  def validate_with_labels(task, label_names)
    in_db_labels = Label.where(name: label_names).pluck(:name)

    errors = []
    errors += task.errors.full_messages unless task.valid?

    label_names.each do |label_name|
      unless in_db_labels.include?(label_name)
        label = Label.new(name: label_name)
        errors += label.errors.full_messages unless label.valid?
      end
    end
    errors.uniq
  end

  def save_with_labels(task, label_names)
    label_names.each do |label|
      return false if Label.find_or_initialize_by(name: label).invalid?

      task.labels << Label.find_or_initialize_by(name: label)
    end

    task.save
  end
end
