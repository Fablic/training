class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all.order('created_at DESC')
  end

  def show
    
  end

  def new
    @task = Task.new()
  end

  def create
    @task = Task.new(task_params)
    # TODO：ステップ16: 複数人で利用できるようにしよう（ユーザの導入）時に合わせて修正
    # 現段階ではユーザーは考慮しないので、NOT NULL制約回避用にダミーデータ格納
    @task.user_id = 0

    if @task.save
      redirect_to @task, notice: t("tasks.flash.new")
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t("tasks.flash.update")
    else
      render :edit
    end
  end

  def destroy

    return unless @task.destroy
    
    redirect_to tasks_path, notice: t("tasks.flash.destroy")
  end

  private

    def task_params
      params.require(:task).permit(:user_id, :title, :description, :termination_at, :priority, :status)
    end

    def set_task
      @task = Task.find(params[:id])
    end
end
