class TasksController < ApplicationController

  # タスク一覧
  def index
    #@tasks = Task.all(:order => 'priority')
    @tasks = Task.all
  end

  # タスク新規登録
  def new
    @task = Task.new
  end

  def show
    @task = Task.find(params[:id])
  end

  # タスク登録実行
  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = "登録が完了しました。"
      redirect_to("/")
    else
      render 'new'
    end
  end

  # タスク詳細
  def detail
    @task = Task.find(params[:id])
  end

  # タスク編集
  def edit
    @task = Task.find(params[:id])
  end

  # タスク更新実行
  def update
    @task = Task.find_by(id: params[:id])
    if @task.update(task_params)
      flash[:success] = "更新が完了しました。"
      redirect_to("/")
    else
      render 'edit'
    end
  end

  # タスク削除
  def delete
    @task = Task.find(params[:id])
  end

  # タスク削除実行
  def destroy
    @task = Task.find_by(id: params[:id])
    
    #データの削除
    if @task.destroy
      flash[:success] = "削除が完了しました。"
      #一覧ページへリダイレクト
      redirect_to("/")
    else
      render 'delete'
    end    
  end
  
  # タスクパラメータ
  private
  def task_params
    params.require(:task).permit(:user_id, :task_title, :task_detail, :deadline_date, :priority, :task_status_id, :task_type_id)
  end

end
