class ApplicationController < ActionController::Base # rubocop:disable Style/Documentation
  around_action :switch_locale

  rescue_from StandardError, with: :render500
  rescue_from ActionController::BadRequest, with: :render400
  rescue_from ActiveRecord::RecordNotFound, with: :render404
  rescue_from ActionController::RoutingError, with: :render404

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  private

  def render400 = render_error(:bad_request, '400')
  def render404 = render_error(:not_found, '404')
  def render500 = render_error(:internal_server_error, '500')

  def render_error(status, template)
    render template: %(errors/#{template}), status:, layout: true
  end
end
