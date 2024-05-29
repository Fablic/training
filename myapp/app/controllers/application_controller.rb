# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :check_maintenance_mode

  # 例外処理
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  # rescue_from Exception, with: :render_500

  def render_404
    render template: "errors/error_404", status: 404, layout: "application", content_type: "text/html"
  end

  def render_500
    render template: "errors/error_500", status: 500, layout: "application", content_type: "text/html"
  end

  private

  def check_maintenance_mode
    if File.exists?(Rails.root.join('tmp', 'maintenance_mode'))
      redirect_to maintenance_path
    end
  end
end
