# frozen_string_literal: true
require 'pp'

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  # GET /tasks or /tasks.json
  def index
    @sort = sort_params
    @name, @status = search_params
    pp @name, @status
    @tasks = Task.search(@name, @status)
    @tasks = Task.sort_tasks(@sort)
  end

  def search
    @sort = sort_params
    @name, @status = search_params
    @tasks = Task.search(@name, @status).sort_tasks(@sort)
    render "index"
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:name, :desc, :status, :label, :priority, :due_date)
  end

  def sort_params
    if check_sort_key && params[:sort_val].present?
      { params[:sort_key]&.to_sym => set_sort_val }
    else
      # by default sorting with created_at in desc order
      { created_at: :desc, due_date: :asc }
    end
  end

  def check_sort_key
    %i[due_date created_at].include?(params[:sort_key]&.to_sym)
  end

  def set_sort_val
    params[:sort_val]&.to_sym.eql?(:desc) ? :desc : :asc
  end

  def search_params
    name = params[:name].nil? ? nil : params[:name]
    status = params[:status].nil? ? nil : params[:status]
    [name, status]
  end

end
