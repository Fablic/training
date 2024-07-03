# frozen_string_literal: true

module Admin
  class ApplicationController < ActionController::Base # rubocop:disable Style/Documentation
    include Authentication
    include Authorization

    layout 'admin'
    before_action :require_sign_in!, :authorize_admin!
  end
end
