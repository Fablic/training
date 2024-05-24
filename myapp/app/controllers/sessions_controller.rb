class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.authenticate(params[:session][:email], params[:session][:password])
    if @user
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
