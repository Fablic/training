class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(:id)
  end

  def new
    @task = Task.new(name: '', description: '', priority: :normal, status: :waiting)
  end

  def edit
    # TODO: Check the task exactly belongs to the user.
    @task = Task.find(params.require(:id))
  end

  def create
    if Task.create(params.require(:task).permit(:name, :description, :due_date, :priority, :status))
      redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.added') }
    else
      redirect_to root_path, flash: { error: I18n.t('pages.tasks.flash.fail') }
    end
  end

  def update
    # TODO: Check the task exactly belongs to the user.
    task = Task.find(params.require(:id))
    if task.update(params.require(:task).permit(:name, :description, :due_date, :priority, :status))
      redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.edited') }
    else
      redirect_to root_path, flash: { error: I18n.t('pages.tasks.flash.fail') }
    end
  end

  def destroy
    # TODO: Check the task exactly belongs to the user.
    task = Task.find(params.require(:id))
    if task.destroy
      redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.deleted') }
    else
      redirect_to root_path, flash: { error: I18n.t('pages.tasks.flash.fail') }
    end
  end
end
