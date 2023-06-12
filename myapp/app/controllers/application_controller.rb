class ApplicationController < ActionController::Base
  before_action :render_503_except, if: :maintenance_mode?
  around_action :switch_locale
  add_flash_types :success, :danger
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  include SessionsHelper

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  private

  def record_not_found(e = nil)
    if e
      logger.info "ActiveRecord::RecordNotFound!: #{e.message}"
      logger.info e.backtrace.join("\n")
    end
    redirect_to root_path, danger: t('error.messages.record_not_found')
  end

  def maintenance_mode?
    ENV['MAINTENANCE_MODE'] == 'false'
  end

  def render_503_except
    render(
      file: Rails.public_path.join('503.html'),
      content_type: 'text/html',
      layout: false,
      status: :service_unavailable,
    )
  end
end
