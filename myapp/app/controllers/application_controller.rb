class ApplicationController < ActionController::Base
  # unless Rails.env.development?
  rescue_from Exception, with: :_render500
  rescue_from ActiveRecord::RecordNotFound, with: :_render404
  rescue_from ActionController::RoutingError, with: :_render404
  # end
  include SessionHelper

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  # 404err
  def _render404
    render 'errors/404.html', status: :not_found, layout: 'error'
  end

  # 500err
  def _render500
    render 'errors/500.html', status: :internal_server_error, layout: 'error'
  end

  def login_check
    redirect_to users_login_path, flash: { danger: t('messages.authenticate.unloginned') } unless logged_in?
  end
end
