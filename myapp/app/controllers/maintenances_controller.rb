class MaintenancesController < ApplicationController
  skip_before_action :maintenance_mode_on!
  before_action :maintenance_mode_off!

  def index
  end

  private

  def maintenance_mode_off!
    mainte_flg = Maintenance.exists?(status: 1)

    return unless mainte_flg == false

    redirect_to root_path
  end
end
