class ApplicationController < ActionController::Base
  rescue_from Exception,                      with: :render500
  rescue_from ActiveRecord::RecordNotFound,   with: :render404
  rescue_from ActionController::RoutingError, with: :render404

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def t(key, options = {})
    format('key = %<controller>s + _controller. + %<action>% + %<key>%', controller: controller_name,
                                                                         action: action_name, key: key)
    super
  end

  private

  def render404(err = nil)
    logger.info "Rendering 404 with excaption: #{err.message}" if err
    render 'errors/404.html', status: :not_found
  end

  def render500(err = nil)
    logger.error "Rendering 500 with excaption: #{err.message}" if err
    render 'errors/500', status: :internal_server_error, layout: 'error'
  end
end
