class UsersController < ApplicationController
  # ログイン
  def new
    render 'login'
  end

  # ログイン実行
  def create
    user = User.find_by(mail_address: params[:session][:mail_address])
    if authenticate(user)
      log_in(user)
      redirect_to tasks_path
    else
      flash.now[:danger] = t 'messages.authenticate.failed'
      render 'login'
    end
  end

  # ログアウト
  def destroy
    log_out
    render 'logout'
  end

  private

  # ユーザー認証
  def authenticate(user)
    user&.authenticate(params[:session][:password])
  end
end
