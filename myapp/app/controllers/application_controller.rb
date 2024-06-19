class ApplicationController < ActionController::Base
  include SessionsHelper, TaskHelper, UsersHelper
  before_action :check_maintenance_mode

  private 

  def check_maintenance_mode
    tmp_file_path = Rails.root.join('tmp', 'maintenance_tmp.txt')
    if File.exist?(tmp_file_path)
      if current_user && !current_user.admin
        render file: Rails.public_path.join('503.html'), status: :service_unavailable
      end
    end
  end
end
