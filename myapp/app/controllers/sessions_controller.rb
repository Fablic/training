class SessionsController < ApplicationController
  # ログイン
  def new
    render 'new'
  end

  # ログイン実行
  def create
    user = find_user
    if authenticate(user)
      log_in(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to tasks_path
    else
      flash.now[:danger] = t 'messages.authenticate.failed'
      render 'sessions/new'
    end
  end

  # ログアウト
  def destroy
    log_out if logged_in?
    render 'sessions/destroy'
  end

  private

  # ユーザー認証
  def authenticate(user)
    user&.authenticate(params[:session][:password])
  end

  def find_user
    User.find_by(mail_address: params[:session][:mail_address])
  end
end
