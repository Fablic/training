class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ArgumentError, with: :invalid_enum

  def not_found
    render json: {error: "Resource not found"}, status: :not_found
  end

  def invalid_enum(exception)
    render json: {error: exception.message}, status: :unprocessable_entity
  end
end
