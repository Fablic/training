class ApplicationController < ActionController::Base
  before_action :show_maintenance_page, if: :maintenance_mode?

  def maintenance_mode?
    ENV["MAINTENANCE_MODE"] == "true"
  end

  def show_maintenance_page
    # ips_in_whitelist = (ENV["ALLOWED_IPS"] || "").split(",")
    # return if ips_in_whitelist.include?(request.remote_ip)

    render(
      file: Rails.public_path.join("503.html"),
      content_type: "text/html",
      layout: false,
      status: :service_unavailable,
    )
  end

  # 例外ハンドル
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
    logger.info "Rendering 404 with exception: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '404 error' }, status: :not_found
    else
      render 'errors/404', status: :not_found, layout: 'error'
    end
  end

  def _render_500(e = nil)
    logger.error "Rendering 500 with exception: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '500 error' }, status: :internal_server_error
    else
      render 'errors/500', status: :internal_server_error, layout: 'error'
    end
  end

  def authenticate_user
    redirect_to login_path unless session[:user]
    @login_user = session[:user]
  end

  def find_labels
    @task_labels = {}
    records = Label.where("deleted = ?", false)
    records.each do | r |
      @task_labels[r.id] = r
    end
  end
end
