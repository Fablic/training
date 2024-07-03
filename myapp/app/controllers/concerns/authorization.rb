# frozen_string_literal: true

module Authorization # rubocop:disable Style/Documentation
  extend ActiveSupport::Concern

  included do
    helper_method :authorize_admin!, :authorize_standard!
  end

  def authorize_admin!
    redirect_to root_path, alert: 'You are not authorized to access this page.' unless current_user&.admin?
  end

  def authorize_standard!
    redirect_to admin_users_path, alert: 'You are not authorized to access this page.' unless current_user&.standard?
  end
end
