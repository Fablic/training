# frozen_string_literal: true

require 'active_support'

module AdminConcern
  extend ActiveSupport::Concern

  def authenticate_admin_user
    redirect_to root_path unless current_user&.admin?
  end
end
