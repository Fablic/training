# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    return redirect_to login_path unless current_user

    if params[:search_form]
      @search_form = SearchForm.new(search_form_params)
    else
      @search_form = SearchForm.new
      @search_form.sort_direction = 'desc'
    end
    @tasks = Task.search_with_condition(@search_form, params[:page], current_user)
  end

  def show
    redirect_to tasks_path
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash.notice = as_success_message(@task.name, 'action-update')
      redirect_to tasks_path
    else
      flash.alert = error_message
      render 'edit'
    end
  end

  def new
    @task = Task.new
  end

  # rubocop:disable Metrics/AbcSize
  def create
    @task = Task.new(task_params)
    @task.app_user = current_user
    if @task.save
      if @task.input_task_label
        @task.input_task_label.split(',')
            .map(&:strip)
            .reject(&:empty?)
            .map { |name| TaskLabel.new(name: name, task: @task).save }
      end

      flash.notice = as_success_message(@task.name, 'action-create')

      redirect_to tasks_path
    else
      flash.alert = error_message
      render 'new'
    end
  end
  # rubocop:enable Metrics/AbcSize

  def destroy
    task = Task.find(params[:id])
    task.destroy!
    flash.notice = as_success_message(task.name, 'action-delete')

    redirect_to tasks_path
  end

  def edit
    @task = Task.find(params[:id])
  end

  # rubocop:disable Metrics/AbcSize
  def add_label
    begin
      task = Task.find(params[:task_id])
      name = params[:name]
      labels = task.task_labels || []

      if labels.map(&:name).include?(name)
        @error_message = I18n.t('msg-label.already-exist')
      else
        @task_label = TaskLabel.new(name: name, task: task)
        @error_message = I18n.t('msg-label.save-error') unless @task_label.save
      end
    rescue => e
      Rails.logger.error e
      @error_message = I18n.t('msg-label.save-error')
    end

    respond_to do |format|
      format.js
    end
  end
  # rubocop:enable Metrics/AbcSize

  def delete_label
    begin
      @task_label = TaskLabel.find(params[:label_id])
      @error_message = I18n.t('msg-label.delete-error') unless @task_label.destroy!
    rescue => e
      Rails.logger.error e
      @error_message = I18n.t('msg-label.delete-error')
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :due_date, :status, :input_task_label)
  end

  def search_form_params
    params.require(:search_form).permit(:sort_direction, :status, :task_label)
  end

  def as_success_message(name, action_key)
    t('msg-success', name: name, action: t(action_key))
  end

  def error_message
    t('msg-error')
  end
end
