class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(user_name: session_params[:name])
    if user.present?
      session[:user_id] = user.id
      redirect_to root_url, notice: 'ログインしました。'
    else
      render :new
    end
  end

  private

  def session_params
    params.require(:session).permit(:name, :password)
  end

end
