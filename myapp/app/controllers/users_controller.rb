class UsersController < ApplicationController
  def login
  end

  def exec_login
    user = User.find_by(mail_address: params[:session][:mail_address])
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to tasks_path
    else
      flash.now[:danger] = t 'messages.authenticate.failed'
      render 'login'
    end
  end

  def logout
    log_out
  end
end
