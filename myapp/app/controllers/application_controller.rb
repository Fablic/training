class ApplicationController < ActionController::Base
    include SessionsHelper

    before_action :login_user
    before_action :check_maintenance

    def check_maintenance
      maintenance = Maintenance.find_by(content_id: ALL_MENTE)
      if maintenance.maintenance_flg
        render(
          file: Rails.public_path.join("503.html"),
          content_type: "text/html",
          layout: false,
          status: :service_unavailable,
        )
      end
    end
  end
