# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :ensure_logged_in

  def index
    @tasks = Task.available(current_user.id).order("#{sort_column} #{sort_direction}").page(params[:page]).per(10)
  end

  def new
    @task = Task.new
    @submit_label = I18n.t('dictionary.words.save_to_create')
  end

  def edit
    @task = Task.available(current_user.id).find_by(id: params[:id])
    @submit_label = I18n.t('dictionary.words.save_to_update')

    @label_ids = TaskLabel.where(task_id: params[:id]).pluck(:label_id)
    @label_names = Label.where(id: @label_ids).pluck(:name)

    render404 if @task.nil?
  end

  def update
    @task = Task.available(current_user.id).find(params[:id])

    if @task.update(task_params)
      create_labels(@task.id)

      redirect_to tasks_path, notice: I18n.t('dictionary.messages.edited_task')
    else
      render :edit
    end
  end

  def show
    id = params[:id]
    @task = Task.available(current_user.id).find_by(id: id)
    @labels = TaskLabel.get_labels(id)

    render404 if @task.nil?
  end

  def create
    params = task_params
    params['user_id'] = current_user.id
    @task = Task.new(params)

    if @task.save
      create_labels(@task.id)
      redirect_to tasks_path, notice: I18n.t('dictionary.messages.created_task')
    else
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
    if !params[:keyword].blank? || !params[:status].blank?
      @tasks = Task.search(params[:keyword], params[:status], current_user.id, "#{sort_column} #{sort_direction}").page(params[:page]).per(10)
      @keyword = params[:keyword]
      @status = params[:status]
    else
      return redirect_to tasks_path
    end

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
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def create_labels(task_id)
    if !task_labels[:labels].blank? && !task_id.nil?
      current_task_label = TaskLabel.where(task_id: task_id)
      current_task_label.delete_all

      @labels = task_labels[:labels].split(",")

      @labels.each do |label|
        if Label.active.where(name: label).count.zero?
          label_for_save = Label.new(name: label)
          label_for_save.save
        else
          label_for_save = Label.active.find_by(name: label)
        end

        tasklabel = TaskLabel.new(task_id: task_id, label_id: label_for_save.id)
        tasklabel.save
      end
    end
  end
end
