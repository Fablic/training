# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :render503, if: :maintenance_mode?

  def maintenance_mode?
    Maintenance.status?
  end

  def render503
    render(
      file: Rails.public_path.join('503.html'),
      content_type: 'text/html',
      layout: false,
      status: :service_unavailable,
    )
  end
end
