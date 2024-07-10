# frozen_string_literal: true

module Admin
  class ApplicationController < ::ApplicationController # rubocop:disable Style/Documentation
    layout 'admin'

    skip_before_action :authorize_standard_operation!
    before_action :authorize_admin_operation!
  end
end
