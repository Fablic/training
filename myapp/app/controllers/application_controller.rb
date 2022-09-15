# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500

  def render_404
    render file: 'public/404', layout: false, status: 404, content_type: 'text/html'
  end

  def render_500
    render file: 'public/500', layout: false, status: 500, content_type: 'text/html'
  end
end
