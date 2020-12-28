class MaintenancesController < ApplicationController
  skip_before_action :require_sign_in!
  skip_before_action :maintenance_mode_on!
  before_action :maintenance_mode_off!

  def index
  end

  def maintenance_mode_off!
    mainte_flg = Maintenance.find(1)

    if mainte_flg.status.zero?
      redirect_to root_path
    end
  end
end
