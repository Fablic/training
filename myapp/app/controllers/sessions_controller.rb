class SessionsController < ::ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'Logged in!'
    else
      flash[:notice] = 'Email or password is invalid'
      render :new
    end
  end
end
