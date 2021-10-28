class SessionsController < ApplicationController
  before_action :logged_in_user, only: %i[destroy]
  before_action :login?, only: %i[new create]

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
    else
      redirect_back fallback_location: login_url, flash: { info: I18n.t('pages.sessions.flash.login') }
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
