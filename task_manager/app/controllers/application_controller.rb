# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :authenticate_user

  def authenticate_user
    return if logged_in?

    flash[:danger] = I18n.t 'application.flash.authentification_user.danger'
    redirect_to('/login')
  end

  def render_404 # rubocop:disable Naming/VariableNumber
    render file: Rails.root.join('public/404.html'), status: :not_found, layout: false, content_type: 'text/html'
  end
end
