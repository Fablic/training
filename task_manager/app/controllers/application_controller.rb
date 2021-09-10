# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AdminHelper
  include SessionsHelper
  before_action :render_503, if: :maintenance_mode? # rubocop:disable Naming/VariableNumber
  before_action :authenticate_user

  def authenticate_user
    return if logged_in?

    flash[:danger] = I18n.t 'application.flash.authentification_user.danger'
    redirect_to('/login')
  end

  def render_404 # rubocop:disable Naming/VariableNumber
    render file: Rails.root.join('public/404.html'), status: :not_found, layout: false, content_type: 'text/html'
  end

  def maintenance_mode?
    File.exist?('./config/maintanance.txt')
  end

  def render_503 # rubocop:disable Naming/VariableNumber
    file = File.open('./config/maintanance.txt', 'r')
    @error = { reason: file.read }
    render template: 'errors/error_503', status: :service_unavailable, layout: 'application', content_type: 'text/html'
  end
end
