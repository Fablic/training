# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  TASKS_PER_PAGE = 5

  def index
    # if params[:search]
    #   @tasks = Task.search_title(params[:search])
    # elsif params[:status] && Task.statuses.include?(params[:status])
    #   @tasks = Task.filter_status(params[:status])
    # else
    #   @tasks = Task.all
    # end

    puts params[:status].blank?

    if params[:search] && !params[:status].blank?
      @tasks = Task.filter_status(params[:status])
      @tasks = @tasks.search_title(params[:search])
    elsif params[:search] && params[:status].blank?
      @tasks = Task.search_title(params[:search])
    else
      @tasks = Task.all
    end

    # session[:is_order_desc] = !session.fetch(:is_order_desc, false)
    # sort_column = params[:sort].presence_in(Task.column_names) ? params[:sort] : "created_at"
    # sort_direction = session[:is_order_desc] ? "DESC" : "ASC"
    # @tasks = @tasks.order("#{sort_column} #{sort_direction}")

    if params[:sort].presence_in(Task.column_names)
      puts params[:is_order_desc]
      sort_column = params[:sort]
      sort_direction = params[:is_order_desc] == 'true' ? "DESC" : "ASC"
      # params[:is_order_desc] = !params[:is_order_desc]
    else
      puts 'YYYYYYYYYYYYYYYYY'
      sort_column = "created_at"
      sort_direction = "DESC"
    end
    puts 'sort_direction'
    puts sort_direction
    puts 'sort_direction'
    @tasks.order("#{sort_column} #{sort_direction}")
    # @tasks = @tasks.sort_by( |task| task.expiration_date,  )

    @tasks = @tasks.page(params[:page]).per(TASKS_PER_PAGE)
    @tasks
  end

  def new
    @task = Task.new
  end

  def show
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: t("tasks.create.notice")
    else
      render :new, alert: t("tasks.create.alert")
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t("tasks.update.notice")
    else
      render :edit, alert: t("tasks.update.alert")
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_path, notice: t("tasks.delete.notice")
    else
      redirect_to tasks_path, alert: t("tasks.delete.alert")
    end
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :expiration_date, :status)
    end
end
