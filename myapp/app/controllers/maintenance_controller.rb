class MaintenanceController < ApplicationController
  def show
    if Rails.application.config.maintenance_mode
      render template: 'maintenance/show'
    else
      redirect_to root_path
    end
  end
end
