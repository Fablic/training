# frozen_string_literal: true

module Authorization # rubocop:disable Style/Documentation
  extend ActiveSupport::Concern

  included do
    helper_method :authorize_admin_operation!, :authorize_standard_operation!
  end

  def authorize_admin_operation!
    return if current_user&.admin? && (session[:oparation_role].nil? || session[:oparation_role] == 'admin')

    redirect_to root_path, alert: 'You are not authorized to access this page.'
  end

  def authorize_standard_operation!
    return if current_user&.standard? || session[:operation_role] == 'standard'

    redirect_to admin_users_path, alert: 'You are not authorized to access this page.'
  end
end
