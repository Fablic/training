class ApplicationController < ActionController::Base
  before_action :maintenance_mode_on!
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

  def maintenance_mode_on!
    mainte_flg = Maintenance.find(1)

    return unless mainte_flg.status == 1

    redirect_to maintenance_path
  end
end
