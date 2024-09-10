# frozen_string_literal: true

require 'uri'

# TaskController is a controller to handle basic CRUD operations for "task"
class TasksController < ApplicationController
  before_action :redirect_to_login_path_if_not_logged_in

  def index
    q = Task

    unless params[:query].to_s.empty?
      # TODO: fix this. this fuzzy search might cause performance degradation.
      q = q.where('title LIKE ?', "%#{ActiveRecord::Base.sanitize_sql_like(params[:query].to_s)}%")
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
    return redirect_to error_path(401) if @task["user_id"] != current_user.id
  end

  def create
    data = task_data(params)
    data["user_id"] = current_user.id
    @task = Task.new(data)
    if @task.save
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
    return redirect_to error_path(401) if @task["user_id"] != current_user.id
  end

  def update
    @task = Task.find_by(id: params[:id])
    return redirect_to error_path(404) if @task.nil?
    return redirect_to error_path(401) if @task["user_id"] != current_user.id

    data = task_data(params)
    data["user_id"] = current_user.id
    if @task.update(data)
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
    return redirect_to error_path(401) if @task["user_id"] != current_user.id

    @task.destroy
    flash[:notice] = I18n.t 'msg_delete_success'
    redirect_to root_path
  end

  private

  def task_data(form_params)
    {
      title: form_params[:task][:title],
      description: form_params[:task][:description],
      due_date_at: form_params[:task][:due_date_at],
      status: form_params[:task][:status].to_i
    }
  end
end
