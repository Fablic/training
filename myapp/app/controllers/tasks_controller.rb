class TasksController < ApplicationController
  def index
    @tasks = Task.order("#{sort_column} #{sort_direction}")
    @direction = sort_direction
  end

  def search
    @title = params[:title]
    @status = params[:status]
    @direction = sort_direction
    @tasks = Task.search(@title, @status).order("#{sort_column} #{sort_direction}")
    render 'index'
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    return render 'new' unless @task.save

    # タスク作成を通知
    flash[:success] = 'Task created!'
    redirect_to root_path
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    # 異常系はearly return
    return render 'edit' unless @task.update(task_params)

    # 正常系をmain blockに残す
    flash[:success] = 'Task updated!'
    redirect_to root_path
  end

  def destroy
    Task.find(params[:id]).destroy
    flash[:success] = 'Task deleted!'
    redirect_to root_path
  end

  private

  def task_params
    # status, priorityはのちのstepで追加する
    params.require(:task).permit(:title, :description, :expire_at, :status)
  end

  # ?sort=hogeでソートするカラムを受け取る. 存在しないカラムの時はtitleでソート
  def sort_column
    # params[:sort]がnilのときはtitleでソート
    col = params[:sort].nil? ? 'title' : params[:sort]
    #Taskのカラム以外が指定されたときはtitleをソート
    Task.column_names.include?(col) ? col : 'title'
  end

  # ?order=asc[desc] で昇順/降順を指定する. 該当しないときはasc
  def sort_direction
    # params[:order]がnilのときは昇順でソートする
    ord = params[:order].nil? ? 'asc' : params[:order]
    # asc/desc以外が指定された時は昇順でソートする
    %[asc desc].include?(ord) ? ord : 'asc'
  end

end
