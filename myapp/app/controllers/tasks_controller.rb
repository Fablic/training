class TasksController < ApplicationController
  before_action :authenticate_user
  before_action :find_labels

  def index
    params[:search_word] = '' unless params[:search_word]
    params[:search_status] = '0' unless params[:search_status]
    params[:page] = 1 unless params[:page]
    @tasks = Task.search(@login_user['id'], params[:search_word], params[:search_status], params[:page])
  end

  def show
    @task = Task.find(params[:id])
    redirect_to tasks_url if @task.user_id != @login_user['id']
  end

  def new
    @task = Task.new
    @task.user_id = @login_user['id']
  end

  def create
    @task = Task.new(task_params)
    redirect_to tasks_url if @task.user_id != @login_user['id']
    if @task.save
      flash[:success] = t('dictionary.message.save.success')
      redirect_to @task # Tasks#showへ
    else
      flash.now[:alert] = t('dictionary.message.save.fail')
      render 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
    redirect_to tasks_url if @task.user_id != @login_user['id']
  end

  def update
    @task = Task.find(params[:id])
    redirect_to tasks_url if @task.user_id != @login_user['id']
    if @task.update(task_params)
      flash[:success] = t('dictionary.message.save.success')
      redirect_to @task
    else
      flash.now[:alert] = t('dictionary.message.save.fail')
      render 'edit'
    end
  end

  def destroy
    task = Task.find(params[:id])
    redirect_to tasks_url if task.user_id != @login_user['id']
    if task.update(deleted: true)
      flash[:success] = t('dictionary.message.destroy.success')
    else
      flash[:alert] = t('dictionary.message.destroy.fail')
    end
    redirect_to tasks_url
  end

  private

  def task_params
    params.require(:task).permit(:user_id, :title, :body, :deadline, :priority, :label_id, :status)
  end
end
