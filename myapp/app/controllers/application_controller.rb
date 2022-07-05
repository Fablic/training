class ApplicationController < ActionController::Base
  include SessionsHelper
  include MaintenanceHelper
  before_action :render_503, if: :maintenance?
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500

  private

  def render_404
    render template: 'errors/404', status: 404, layout: 'application', content_type: 'text/html'
  end

  def render_500
    render template: 'errors/500', status: 500, layout: 'application', content_type: 'text/html'
  end

  # メンテナンスは503
  def render_503
    render template: 'errors/503', status: 503, layout: 'application', content_type: 'text/html'
  end
end
