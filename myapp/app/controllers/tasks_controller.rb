class TasksController < ApplicationController
  def index
    params[:search_word] = '' unless params[:search_word]
    params[:search_status] = '0' unless params[:search_status]
    params[:page] = 1 unless params[:page]
    @tasks = Task.search(params[:search_word], params[:search_status], params[:page])
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
    @task.user_id = 1
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = I18n.t('dictionary.message.save.success')
      redirect_to @task # Tasks#showへ
    else
      flash.now[:alert] = I18n.t('dictionary.message.save.fail')
      render 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    logger.debug "update: #{task_params}"
    logger.debug "update: #{Date.today}"
    if @task.update(task_params)
      flash[:success] = I18n.t('dictionary.message.save.success')
      redirect_to @task
    else
      flash.now[:alert] = I18n.t('dictionary.message.save.fail')
      render 'edit'
    end
  end

  def destroy
    task = Task.find(params[:id])
    if task.update(deleted: true)
      flash[:success] = I18n.t('dictionary.message.destroy.success')
    else
      flash[:alert] = I18n.t('dictionary.message.destroy.fail')
    end
    redirect_to tasks_url
  end

  private

  def task_params
    params.require(:task).permit(:user_id, :title, :body, :deadline, :priority, :label_id, :status)
  end
end
