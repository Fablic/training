# frozen_string_literal: true

class TasksController < ApplicationController
  # タスク一覧画面
  def index
    user_id = @current_user.id

    if params[:q].nil?
      # デフォルトの並び順をセット
      params[:q] = { sorts: 'created_at desc' }

      # デフォルトの検索
      @search = Task.ransack()

      # 全件取得
      @tasks = Task.where(user_id: user_id).page(params[:page]).per(Task::PER_PAGE_NO)
    else
      # 入力に応じて検索機能を設定
      @search = Task.ransack(params.require(:q).permit(:sorts, :status_eq, :title_cont, :tags_name_eq))

      # 検索機能を利用した検索結果を取得
      @tasks = @search.result.where(user_id: user_id).page(params[:page]).per(Task::PER_PAGE_NO)
    end
  end

  # タスク登録画面
  def newtask
    # タスクインスタンスの生成
    @task = Task.new

    # Viewの呼び出し
    render tasks_newtask_path
  end

  # タスク登録処理
  def createtask
    @task = Task.new(user_params)

    # 登録成功
    if @task.save
      flash[:success] = I18n.t('msg.success_registration')
      redirect_to action: :index
    # 失敗
    else
      flash.now[:warning] = I18n.t('msg.failed_registration')
      render tasks_newtask_path
    end
  end

  # タスク詳細
  def taskdetail
    # Getパラメータの取得
    param_id = params[:id]

    # パラメータのIDを元にタスクテーブルを検索
    @task_infos = Task.find(param_id)
  end

  # タスク更新
  def taskupdate
    # Getパラメータの取得
    param_id = params[:id]

    # パラメータのIDを元にタスクテーブルを検索
    @task = Task.find(param_id)
  end

  # タスク更新処理
  def taskupdateprocess
    data = params.require(:task).permit(:id, :status, :title, :detail, :end_date, :tag_list)
    data[:status] = params[:task][:status].to_i
    update_task = Task.find(params[:task][:id])
    result = update_task.update(data)

    # 更新成功
    if result
      flash[:success] = I18n.t('msg.success_update')
      redirect_to action: :index
    # 失敗
    else
      flash.now[:warning] = I18n.t('msg.failed_update')
      render tasks_taskupdate_path
    end
  end

  def taskdelete
    # Getパラメータの取得
    param_id = params[:id]

    # 削除実行
    del_task = Task.destroy(param_id)

    # 削除成功
    if del_task
      flash[:success] = I18n.t('msg.success_delete')
      redirect_to action: :index
    # 失敗
    else
      flash.now[:warning] = I18n.t('msg.failed_delete')
      render tasks_taskdetail_path
    end
  end

  def params_int(model_params)
    model_params.each do |key, value|
      if integer_string?(value)
        model_params[key] = value.to_i
      end
    end
  end

  private

  def user_params
    data = params.require(:task).permit(:status, :title, :detail, :end_date, :tag_list)
    # statusはenumのテキスト型なので、整数型に変換する
    data[:status] = params[:task][:status].to_i
    user_id = @current_user.id
    data[:user_id] = user_id
    data
  end
end
