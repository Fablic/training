# frozen_string_literal: true

require 'uri'

# TaskController is a controller to handle basic CRUD operations for "task"
class TasksController < ApplicationController
  before_action :redirect_to_login_path_if_not_logged_in, :redirect_to_maintenance

  def index
    q = Task

    unless params[:query].to_s.empty?
      # TODO: fix this. this fuzzy search might cause performance degradation.
      q = q.where('title LIKE ?', "%#{ActiveRecord::Base.sanitize_sql_like(params[:query].to_s)}%")

      # find if there is matched label
      labels = TasksLabel.joins(:label).where('labels.name': params[:query].to_s).pluck('task_id')
      if labels.any?
        q = q.or(Task.where(id: labels))
      end
    end

    q = q.where(status: params[:status]) unless params[:status].to_s.empty?

    sort_param = params[:sort].to_s.downcase
    sort = case sort_param
           when 'due_date_at'
             sort_param
           else
             'created_at'
           end
    # TODO: support ascending
    sort += ' DESC'

    @tasks = q.where(user_id: current_user.id).order(sort).page(params[:page])

    # for new form
    @new_task = Task.new
  end

  def show
    @task = Task.find_by(id: params[:id])
    return redirect_to error_path(404) if @task.nil?
    return redirect_to error_path(401) if @task.user_id != current_user.id && (!current_user.role_moderator? and !current_user.role_admin?)

    @labels = Label.joins(:tasks_labels).where('tasks_labels.task_id': params[:id])
  end

  def create
    @task = Task.new(create_params)
    if @task.save

      # insert labels, this func doesn't throw error for now in order to proceed
      # main process to create task, then we could make it async later
      add_labels(@task, params[:task][:labels])

      flash[:success] = I18n.t 'msg_create_success'
      redirect_to root_path
    else
      flash.now[:danger] = I18n.t 'msg_create_failure'

      @new_task = @task
      @tasks = Task.where(user_id: current_user.id).order('created_at DESC').page(params[:page])
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find_by(id: params[:id])
    return redirect_to error_path(404) if @task.nil?
    return redirect_to error_path(401) if @task.user_id != current_user.id

    @labels_value = ''
    labels = Label.joins(:tasks_labels).where('tasks_labels.task_id': params[:id])
    if labels.any?
      labels.each do |label|
        @labels_value += ' ' unless @labels_value.empty?
        @labels_value += label.name
      end
    end
  end

  def update
    @task = Task.find_by(id: params[:id])
    return redirect_to error_path(404) if @task.nil?
    return redirect_to error_path(401) if @task.user_id != current_user.id

    if @task.update(update_params)

      # delete them all first and re-create, should be better performance than select and update for each
      if delete_labels?(@task)
        add_labels(@task, params[:task][:labels])
      end

      flash[:success] = I18n.t 'msg_update_success'
      redirect_to root_path
    else
      flash.now[:danger] = I18n.t 'msg_update_failure'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      flash[:danger] = I18n.t 'msg_delete_failure'
      return redirect_to root_path
    end
    return redirect_to error_path(401) if @task.user_id != current_user.id

    @task.destroy
    flash[:success] = I18n.t 'msg_delete_success'
    redirect_to root_path
  end

  private

  def create_params
    # value coming from select field is string, convert it to int explcitly here
    params[:task][:status] = params[:task][:status].to_i
    params[:task][:user_id] = current_user.id
    params.require(:task).permit(:title, :description, :due_date_at, :status, :user_id)
  end

  def update_params
    # value coming from select field is string, convert it to int explcitly here
    params[:task][:status] = params[:task][:status].to_i
    params.require(:task).permit(:title, :description, :due_date_at, :status)
  end

  def add_labels(task, labels)
    return if labels.empty? || labels.nil?

    labels = labels.split(/[\s|,]/).reject { |s| s.empty? }

    # too many labels, limit to 50, or should return error?
    # TODO, the val is hard-coded here for now, but make it configurable
    max_labels = 50
    if labels.length >= max_labels
      labels = labels[0..(max_labels - 1)]
    end

    labels_map = {}
    labels.each do |v|
      labels_map[v] = 1
    end

    res = Label.where(name: labels)

    # construct `data` for bulk insert
    data = []
    # for existing labels
    res.each do |item|
      data.push({ "label_id": item.id, "task_id": task.id })
      labels_map.delete(item.name) if labels_map.key?(item.name)
    end

    result = ActiveRecord::Base.transaction do
      # for new labels
      # insert them one by one in order to get the id, mysql w/ AR doesn't support returning object for bulk insert
      if labels_map.length > 0
        labels_map.each do |item, v|
          l = Label.new({ name: item })
          res = l.save
          data.push({ "label_id": l.id, "task_id": task.id }) if res
        end
      end

      # bulk insert labels for this task
      TasksLabel.insert_all data
    end

    unless result
      # should return error?
      Rails.logger.error("failed to insert lables, error: #{result}")
    end
  end

  def delete_labels?(task)
    TasksLabel.where(task_id: task.id).destroy_all
  end

end
