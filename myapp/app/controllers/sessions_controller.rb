class SessionsController < ApplicationController
  skip_before_action :logged_in_user, only: %i[new create]
  before_action :login?, only: %i[new create]

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
    else
      flash.now[:danger] = I18n.t('pages.sessions.flash.login')
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_url
  end

  private

  def login?
    redirect_to(root_url) if logged_in?
  end
end
