class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user.present?
      pass_digest = Digest::MD5.hexdigest(session_params[:password])
      password = Digest::MD5.hexdigest(pass_digest + user.salt)
      if user.password == password
        session[:user_id] = user.id
        redirect_to root_url, notice: 'ログインしました。'
      else
        flash.now[:alert] = 'ログインに失敗しました。'
        render :new
      end
    else
      flash.now[:alert] = 'ログインに失敗しました。'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    render :new, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
