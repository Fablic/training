# frozen_string_literal: true

class ApplicationController < ActionController::Base # rubocop:disable Style/Documentation
  # Added `rescue_from` here for the assignment, but it is planned to be removed
  rescue_from StandardError, with: :render_internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def render_not_found
    render file: Rails.root.join('public/404.html'), status: :not_found
  end

  def render_internal_server_error(exception)
    logger.error(exception.message)
    logger.error(exception.backtrace.join("\n"))

    render file: Rails.root.join('public/500.html'), status: :internal_server_error
  end
end
