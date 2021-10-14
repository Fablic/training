class TasksController < ApplicationController
  def index
    @tasks = Task.paginate(page: params[:page])
  end

  def new
    @task = Task.new
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    @task.image.attach(params[:task][:image])
    if @task.save
      redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.added') }
    else
      flash.now[:danger] = I18n.t('pages.tasks.flash.fail')
      render 'new'
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.image.attach(task_params[:image]) if task_params.key?(:image)
    if @task.update(task_params)
      redirect_to @task, flash: { info: I18n.t('pages.tasks.flash.edited') }
    else
      flash.now[:danger] = I18n.t('pages.tasks.flash.fail')
      render 'edit'
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.deleted') }
  end

  private

  def task_params
    params.require(:task).permit(:title, :detail, :priority, :status, :due_date, :image)
  end
end
