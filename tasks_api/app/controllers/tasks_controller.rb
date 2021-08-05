# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    order =
      case params[:order]
      when 'due_date'
        { due_date: :asc }
      when 'due_date_desc'
        { due_date: :desc }
      else
        { created_at: :desc }
      end

    @tasks = apply_queries(Task.all.order(order), params)

    @tasks = @tasks.page(params[:page])
  end

  def show
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    flash.now['notice'] = I18n.t('notice.created')

    if @task.save
      render :show, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: e, status: :unprocessable_entity
  end

  def update
    @task = Task.find(params[:id])
    flash.now['notice'] = I18n.t('notice.updated')

    if @task.update(task_params)
      render :show
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    flash.now['notice'] = I18n.t('notice.deleted')

    if @task.destroy
      render
    else
      head :unprocessable_entity
    end
  end

  private

  def task_params
    params.fetch(:task, {}).permit(%i[name description due_date status])
  end

  def apply_queries(tasks, params)
    if params[:q]
      keywords = Shellwords.shellwords(params[:q])
      tasks = tasks.where('match(name) against (? in boolean mode)', keywords.map { |k| "+#{k}" }.join(' '))
    end

    tasks = tasks.where(status: params[:status]) if params[:status]

    tasks
  end
end
