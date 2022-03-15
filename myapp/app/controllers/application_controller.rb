class ApplicationController < ActionController::Base
    before_action :current_user
    before_action :require_sign_in!
    helper_method :signed_in?

    protect_from_forgery with: :exception

    rescue_from Exception,                      with: :_render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404

    def routing_error
      raise ActionController::RoutingError, params[:path]
    end

    private

    def _render_404(e = nil)
      logger.info "Rendering 404 with excaption: #{e.message}" if e

      if request.format.to_sym == :json
        render json: { error: '404 Not Found' }, status: :not_found
      else
        render 'errors/404.html', status: :not_found, layout: 'error'
      end
    end

    def _render_500(e = nil)
      logger.error "Rendering 500 with excaption: #{e.message}" if e

      if request.format.to_sym == :json
        render json: { error: '500 Internal Server Error' }, status: :internal_server_error
      else
        render 'errors/500', status: :internal_server_error, layout: 'error'
      end
    end

    def current_user
        remember_token = User.encrypt(cookies[:user_remember_token])
        @current_user ||= User.find_by(remember_token: remember_token)
    end

    def sign_in(user)
        remember_token = User.new_remember_token
        cookies.permanent[:user_remember_token] = remember_token
        user.update!(remember_token: User.encrypt(remember_token))
        @current_user = user
    end

    def sign_out
        cookies.delete(:user_remember_token)
    end

    def signed_in?
        @current_user.present?
    end

    private
    def require_sign_in!
        redirect_to login_path unless signed_in?
    end
end
