# frozen_string_literal: true

class MaintenanceController < ApplicationController

  skip_before_action :logged_in_user
  skip_before_action :maintenance_mode_on!
  before_action :maintenance_mode_off!

  def index
  end

  def maintenance_mode_off!
    maintenance_flg = Maintenance.find(1)
    if maintenance_flg.status.zero?
      redirect_to root_path
    end
  end
end
