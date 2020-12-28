class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :maintenance_mode_on!
  before_action :require_sign_in!

  private

  def require_sign_in!
    unless logged_in?
      redirect_to login_path
    end

    def maintenance_mode_on!
      mainte_flg = Maintenance.find(1)

      if mainte_flg.status == 1
        redirect_to maintenance_index_path
      end
    end
  end
end
