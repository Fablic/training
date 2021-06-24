# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    render file: Rails.root.join('public/404.html'), status: 404
  end

  def render_500(e = nil)
    logger.info "Rendering 500 with exception: #{e.message}" if e

    render file: Rails.root.join('public/500.html'), status: 500
  end
end
