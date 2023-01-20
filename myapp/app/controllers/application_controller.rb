# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails

  before_action :render_server_unavaliable, if: :maintenance_mode?

  rescue_from Exception, with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def authorize_user
    redirect_to login_url if Current.user.nil?
  end

  def not_found
    render 'errors/404.html', status: :not_found
  end

  def internal_server_error
    render 'errors/500.html', status: :internal_server_error
  end

  def maintenance_mode?
    YAML.load_file('maintinance.yml').with_indifferent_access['mode'] == 'on'
  end

  def render_server_unavaliable
    render 'errors/503.html', status: :service_unavailable
  end
end
