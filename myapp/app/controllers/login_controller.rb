class LoginController < ApplicationController
  skip_before_action :require_login

  def index
    @user = User.new
  end

  def create
    name, password = params.require(:user).permit(:name, :password).values_at(:name, :password)
    user = User.find_by(name: name)
    if user&.authenticate(password)
      login(user)
      redirect_to root_path(I18n.locale)
    else
      @user = User.new(name: name)
      flash.now[:error] = I18n.t('pages.login.flash.error')
      render :index
    end
  end
end
