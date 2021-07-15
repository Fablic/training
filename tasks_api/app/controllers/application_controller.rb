# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::Flash
  include HttpAcceptLanguage::AutoLocale
end
