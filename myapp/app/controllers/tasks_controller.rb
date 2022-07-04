class TasksController < ApplicationController
  before_action :logged_in_user
  PAGE_NUM = 10

  def index
    @tasks = Task.where(user_id: session[:user_id]).includes(:labels).order("#{sort_column} #{sort_direction}").page(params[:page]).per(PAGE_NUM)
    @direction = sort_direction
  end

  def search
    @title = params[:title]
    @status = params[:status]
    @label = params[:labels]
    @direction = sort_direction
    @tasks = Task.where(user_id: session[:user_id])
                 .includes(:task_labels)
                 .includes(:labels)
                 .search_title(@title)
                 .search_status(@status)
                 .search_label(@label)
                 .order("#{sort_column} #{sort_direction}")
                 .page(params[:page])
                 .per(PAGE_NUM)
    render 'index'
  end

  def show
    @task = Task.where(user_id: session[:user_id]).find(params[:id])
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
    @task = Task.where(user_id: session[:user_id]).find_by(id: params[:id])
    redirect_to login_path if @task.nil?
  end

  def update
    @task = Task.where(user_id: session[:user_id]).find(params[:id])

    # 異常系はearly return
    return render 'edit' unless @task.update(task_params)

    # 正常系をmain blockに残す
    flash[:success] = 'Task updated!'
    redirect_to root_path
  end

  def destroy
    Task.where(user_id: session[:user_id]).find(params[:id]).destroy
    flash[:success] = 'Task deleted!'
    redirect_to root_path
  end

  private

  def task_params
    # status, priorityはのちのstepで追加する
    params.require(:task).permit(:title, :description, :expire_at, :status).merge(user_id: current_user.id)
  end

  # ?sort=hogeでソートするカラムを受け取る. 存在しないカラムの時はtitleでソート
  def sort_column
    # params[:sort]がnilのときはtitleでソート
    col = params[:sort].nil? ? 'title' : params[:sort]
    # Taskのカラム以外が指定されたときはtitleをソート
    Task.column_names.include?(col) ? col : 'title'
  end

  # ?order=asc[desc] で昇順/降順を指定する. 該当しないときはasc
  def sort_direction
    # params[:order]がnilのときは昇順でソートする
    ord = params[:order].nil? ? 'asc' : params[:order]
    # asc/desc以外が指定された時は昇順でソートする
    %(asc desc).include?(ord) ? ord : 'asc'
  end

  def logged_in_user
    redirect_to login_path unless logged_in?
  end
end
