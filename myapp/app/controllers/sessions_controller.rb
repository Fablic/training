class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user.blank?
      flash[:alert] = 'ログインに失敗しました。ログイン情報を入力し直してください。'
      redirect_to login_path and return
    end

    pass_digest = Digest::MD5.hexdigest(session_params[:password])
    password = Digest::MD5.hexdigest(pass_digest + user.salt)

    if user.password == password
      session[:user_id] = user.id
      redirect_to root_url
    else
      flash[:alert] = 'ログインに失敗しました。ログイン情報を入力し直してください。'
      redirect_to login_path
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
