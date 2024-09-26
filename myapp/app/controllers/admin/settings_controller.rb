class Admin::SettingsController < ApplicationController
  before_action :redirect_to_login_path_if_not_logged_in, :redirect_to_root_path_if_normal_role

  def index
    @maintenance = Maintenance.last
    if @maintenance.nil?
      @maintenance = Maintenance.new
    end
  end

  def create
    @maintenance = Maintenance.new(create_params)
    if @maintenance.save
      flash[:success] = I18n.t 'msg_update_success'

      redirect_to admin_settings_path
    else
      flash.now[:danger] = I18n.t 'msg_update_failure'
      render :index, status: :unprocessable_entity
    end
  end

  def create_params
    params[:maintenance][:is_maintenance] = Maintenance.is_maintenances[params[:maintenance][:is_maintenance]].to_i
    params.require(:maintenance).permit(:is_maintenance, :started_at, :ended_at)
  end

end
