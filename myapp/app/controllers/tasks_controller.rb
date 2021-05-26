class TasksController < ApplicationController
  include ErrorValidationExtractor

  PER_PAGE = 10

  def index
    @params = params.permit(:name, :status).select { |_k, v| v.presence }
    @tasks = current_user!.tasks.order(:id).page(params[:page]).per(PER_PAGE)
    @tasks = @tasks.name_with(@params[:name]) if @params[:name]
    @tasks = @tasks.where(status: @params[:status]) if @params[:status]
  end

  def new
    @task = Task.new(user: current_user!, name: '', description: '', priority: :normal, status: :waiting)
  end

  def edit
    @task = current_user!.tasks.find(params.require(:id))
  end

  def create
    task = Task.new(params.require(:task).permit(:name, :description, :due_date, :priority, :status))
    task.user = current_user!
    if task.save
      redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.added') }
    else
      redirect_to root_path, flash: { error: error_message_from(task) }
    end
  end

  def update
    task = current_user!.tasks.find(params.require(:id))
    if task.update(params.require(:task).permit(:name, :description, :due_date, :priority, :status))
      redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.edited') }
    else
      redirect_to root_path, flash: { error: error_message_from(task) }
    end
  end

  def destroy
    task = current_user!.tasks.find(params.require(:id))
    if task.destroy
      redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.deleted') }
    else
      redirect_to root_path, flash: { error: error_message_from(task) }
    end
  end
end
