class SessionsController < ApplicationController
  before_action :require_login, only: [:destroy]
  def new; end

  def create
    user = User.find_by(personal_id: params[:personal_id].downcase)
    if user && user&.authenticate(params[:password])
      if request.referer&.include?('/admin/') && user.admin == 'general'
        flash.now[:danger] = t('.general_cannot_login')
        return render 'new_admin'
      end

      log_in(user)
      return redirect_to users_path if request.referer&.include?('/admin/')
      redirect_to task_schedule_index_path

    else
      flash.now[:danger] = t('.danger')
      return render 'new_admin' if request.referer&.include?('/admin/')
      render 'new'
    end
  end

  def destroy
    log_out
    if request.referer&.include?('/admin/')
      redirect_to admin_login_path
    else
      redirect_to login_path
    end
  end
end
