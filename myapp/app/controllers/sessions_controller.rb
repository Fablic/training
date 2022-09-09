class SessionsController < ApplicationController
  before_action :require_login, only: [:destroy]
  def new; end

  def create
    user = User.find_by(personal_id: params[:personal_id].downcase)
    if user && user&.authenticate(params[:password])
      log_in(user)
      redirect_to task_schedule_index_path
    else
      flash.now[:denger] = t('.danger')
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
