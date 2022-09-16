# frozen_string_literal: true

class TaskScheduleController < ApplicationController
  before_action :require_login
  def index
    @search_params = task_search_params
    @tasks = if params[:desc]
               Task.search(@search_params).desc.page(params[:page]).eager_load(:user).preload(:labels).where(user_id: session[:user_id])
             elsif params[:asc]
               Task.search(@search_params).asc.page(params[:page]).eager_load(:user).preload(:labels).where(user_id: session[:user_id])
             elsif params[:finish_desc]
               Task.search(@search_params).finish_desc.page(params[:page]).eager_load(:user).preload(:labels).where(user_id: session[:user_id])
             elsif params[:finish_asc]
               Task.search(@search_params).finish_asc.page(params[:page]).eager_load(:user).preload(:labels).where(user_id: session[:user_id])
             else
               Task.search(@search_params).finish_asc.page(params[:page]).eager_load(:user).preload(:labels).where(user_id: session[:user_id])
             end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = t('.success')
      redirect_to action: 'index'
    else
      flash.now[:danger] = t('.danger')
      render 'task_schedule/edit'
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = t('.success')
      redirect_to action: 'index'
    else
      flash.now[:danger] = t('.danger')
      render 'task_schedule/new'
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def destroy
    if Task.find(params[:id]).destroy
      flash[:success] = t('.success')
      redirect_to action: 'index'
    else
      flash.now[:danger] = t('.danger')
      render 'task_schedule/index'
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :body, :finish_at, :status, :user_id, { label_ids: [] })
  end

  def task_search_params
    params.fetch(:search, {}).permit(:title, :status,  label_ids: [] )
  end
end
