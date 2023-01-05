class SessionsController < ::ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_url, notice: I18n.t('session.log_in.success_message')
    else
      flash[:notice] = I18n.t('session.log_in.failed_message')
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    Current.user = nil

    redirect_to root_url, notice: I18n.t('session.log_out.success_message')
  end
end
