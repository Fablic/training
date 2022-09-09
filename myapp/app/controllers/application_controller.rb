# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500

  def render_404
    render template: 'errors/404', status: 404, layout: 'application', content_type: 'text/html'
  end

  def render_500
    render template: 'errors/500', status: 500, layout: 'application', content_type: 'text/html'
  end
end
