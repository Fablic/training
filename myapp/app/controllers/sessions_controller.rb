class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: session_params[:email])
    # @user_pass = User.find_by(email: session_params[:password])
    if @user.nil?
      flash.now[:error] = 'メールアドレスが一致しません'
      render(:new)
    # elsif @user_pass.nil?
    #   flash.now[:error] = 'パスワードが一致しません'
    #   puts session_params[:password]
    #   render(:new)
    else
      login(@user)
      redirect_to(root_path)
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

  def login(user)
    session[:user_id] = user.id
  end
end
