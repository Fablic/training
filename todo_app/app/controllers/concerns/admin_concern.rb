# frozen_string_literal: true

require 'active_support'

module AdminConcern
  extend ActiveSupport::Concern

  def authenticate_admin_user
    redirect_to root_path, { flash: { warning: I18n.t(:'message.required_admin_role') } } unless current_user&.admin?
  end
end
