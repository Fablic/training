class ApplicationController < ActionController::Base

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end


  # unless Rails.env.development?
    rescue_from Exception,                        with: :_render_500
    rescue_from ActiveRecord::RecordNotFound,     with: :_render_404
    rescue_from ActionController::RoutingError,   with: :_render_404
  # end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private
    def _render_404(e = nil)
      Rails.logger.info "Rendering 404 with exception: #{e.message}" if e

      render 'errors/404', status: :not_found
    end

    def _render_500(e = nil)
      Rails.logger.error "Rendering 500 with exception: #{e.message}" if e

      render 'errors/500', status: :internal_server_error
    end
end
