class LoginController < ApplicationController
  def index
  end

  def auth
    @login_user = authenticate
    if @login_user.nil?
      # 認証失敗
      flash.now[:alert] = t('dictionary.message.login.fail')
      render 'index'
      return
    end
    # 認証成功
    # セッションに必要な情報を保存
    session[:user] = User.new
    session[:user]['id'] = @login_user.id
    session[:user]['name'] = @login_user.name
    session[:user]['email'] = @login_user.email
    # タスク一覧へ
    redirect_to tasks_url
  end

  def logout
    session[:user] = nil
    redirect_to login_url
  end

  private

  def authenticate
    return nil if params[:account].empty? || params[:password].empty?
    User.find_by("deleted = ? AND email = ? AND password = ?", false, params[:account], params[:password])
  end

end
