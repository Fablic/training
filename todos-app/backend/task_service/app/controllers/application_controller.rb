class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ArgumentError, with: :invalid_enum

  def unprocessable_entity(exception)
    render json: exception.record.errors, status: :unprocessable_entity
  end

  def invalid_enum(exception)
    render json: {error: exception.message}, status: :unprocessable_entity
  end

  def not_found(exception)
    render json: {error: exception.message}, status: :not_found
  end
end
