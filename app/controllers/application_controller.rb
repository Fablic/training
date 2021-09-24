class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :logged_in_user
  before_action :check_maintenance, if: :is_maintenance_mode?

  private
    def logged_in_user
      redirect_to login_url unless logged_in?
    end

    def check_maintenance
      render file: Rails.root.join('public/503.html'), layout: false, status: 503
    end

    def is_maintenance_mode?
      File.exist?('tmp/maintenance.txt')
    end
end
