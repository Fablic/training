class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction, :search_params

  def index
    @search_params = search_params
    @tasks = Task.search(@search_params).paginate(page: params[:page]).order("#{sort_column} #{sort_direction}")
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
      render 'new'
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.image.attach(task_params[:image]) if task_params.key?(:image)
    if @task.update(task_params)
      redirect_to @task, flash: { info: I18n.t('pages.tasks.flash.edited') }
    else
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

  def search_params
    params.permit(:title, :status)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'id'
  end
end
