class ApplicationController < ActionController::Base
  around_action :switch_locale
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

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
    redirect_to root_path, alert: t('error.messages.record_not_found')
  end
end
