class SessionsController < ApplicationController
  before_action :require_login, only: [:destroy]
  def new; end

  def create
    user = User.find_by(personal_id: params[:personal_id].downcase)
    if user && user&.authenticate(params[:password])
      if request.referer&.include?('/admin/')
        if user.admin
          log_in(user)
          redirect_to users_path
        else
          flash[:denger] = t('.not_admin')
          redirect_to admin_login_path
        end

      else
        log_in(user)
        redirect_to task_schedule_index_path
      end
    else
      flash[:denger] = t('.danger')
      if request.referer&.include?('/admin/')
        redirect_to admin_login_path
      else
        redirect_to login_path
      end
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
