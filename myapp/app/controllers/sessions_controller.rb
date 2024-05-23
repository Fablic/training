class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:session][:email])
    if @user && @user[:password] == params[:session][:password]
      session[:user_id] = @user.id
      redirect_to '/'
    else
      redirect_to 'login'
    end
  end

  def destroy
    session.delete :user_id
    redirect_to '/'
  end
end
