# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: e, status: :not_found
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
  rescue ActiveRecord::RecordNotFound
    head :unprocessable_entity
  end

  private

  def task_params
    params.fetch(:task, {}).permit(%i[name description])
  end
end
